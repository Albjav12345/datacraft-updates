"""Publisher-only metadata validation/build; no commercial source or private keys."""
from pathlib import Path
import argparse,base64,datetime,hashlib,json,re,shutil,subprocess,tempfile
ROOT=Path(__file__).resolve().parent
def unique(items):
    result={}
    for key,value in items:
        if key in result:raise ValueError('Duplicate JSON property: '+key)
        result[key]=value
    return result
def load(path):return json.loads(Path(path).read_text(encoding='utf-8-sig'),object_pairs_hook=unique)
def keys(value,names):
    if not isinstance(value,dict) or set(value)!=set(names.split()):raise ValueError('Missing or unknown metadata properties.')
def text(value,maximum=1000,empty=False):
    if not isinstance(value,str) or len(value)>maximum or (not empty and not value.strip()) or any(ord(c)<32 and c not in '\n\t' for c in value):raise ValueError('Invalid release text.')
    return value
def version(value):
    text(value,64)
    if not re.fullmatch(r'(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)',value):raise ValueError('Release versions must be stable major.minor.patch without build aliases.')
    parts=tuple(map(int,value.split('.')))
    if any(n>2147483647 for n in parts):raise ValueError('Version component too large.')
    return parts
def date(value):return datetime.datetime.strptime(text(value,24),'%Y-%m-%dT%H:%M:%SZ').replace(tzinfo=datetime.timezone.utc)
def validate(data):
    keys(data,'packageName releases')
    if data['packageName']!='dev.amedina.datacraft' or not isinstance(data['releases'],list) or len(data['releases'])>48:raise ValueError('Wrong package or excessive history.')
    seen=set()
    for row in data['releases']:
        keys(row,'version minimumUnity publishedAtUtc kind importance summary changes affectsFrom affectsBefore mitigation stores')
        v=version(row['version'])
        if v in seen:raise ValueError('Duplicate release version.')
        seen.add(v)
        if not re.fullmatch(r'\d{1,5}\.\d{1,3}\.\d{1,4}[abfp]\d{1,4}',row['minimumUnity']):raise ValueError('Full Unity version required.')
        if date(row['publishedAtUtc'])>datetime.datetime.now(datetime.timezone.utc):raise ValueError('Do not announce future releases.')
        if row['kind'] not in ['features','fixes','security'] or row['importance'] not in ['normal','recommended','critical']:raise ValueError('Invalid kind or importance.')
        if row['kind']=='features' and row['importance']=='critical':raise ValueError('Features cannot masquerade as a critical fix.')
        if not version(row['affectsFrom'])<version(row['affectsBefore'])<=v:raise ValueError('Invalid explicit affected range.')
        text(row['summary'],500);text(row['mitigation'],1600,True)
        if not isinstance(row['changes'],list) or not 1<=len(row['changes'])<=16:raise ValueError('Between one and sixteen release notes required.')
        for change in row['changes']:text(change,1000)
        keys(row['stores'],'assetStore itch')
        if any(type(value)!=bool for value in row['stores'].values()) or not any(row['stores'].values()):raise ValueError('At least one store must actually offer this release; drafts belong outside the published history.')
    return sorted(data['releases'],key=lambda r:version(r['version']),reverse=True)
def build(output,sequence):
    if sequence<1:raise ValueError('Positive monotonically increasing sequence required.')
    data=load(ROOT/'releases.json');releases=validate(data)
    payload={'packageName':data['packageName'],'sequence':sequence,'issuedAtUtc':datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'),'releases':releases}
    raw=json.dumps(payload,ensure_ascii=False,separators=(',',':')).encode('utf-8')
    if len(raw)>90000:raise ValueError('Signed payload exceeds client limit.')
    Path(output).write_bytes(raw)
    common=next((r for r in releases if r['stores']['itch']),None)
    legacy={'schemaVersion':1,'packageName':data['packageName'],'latest':None if common is None else {'version':common['version'],'minimumUnity':common['minimumUnity'],'releaseNotesUrl':''}}
    (ROOT/'latest.json').write_text(json.dumps(legacy,indent=2)+'\n',encoding='utf-8')
def verify():
    envelope=load(ROOT/'updates-v2.json');keys(envelope,'format formatVersion keyId payload signature')
    if envelope['format']!='DataCraft.Updates' or envelope['formatVersion']!=2 or envelope['keyId']!='publisher-2026-10':raise ValueError('Unknown envelope identity.')
    raw=base64.b64decode(envelope['payload'],validate=True);sig=base64.b64decode(envelope['signature'],validate=True)
    payload=json.loads(raw.decode('utf-8'),object_pairs_hook=unique);keys(payload,'packageName sequence issuedAtUtc releases')
    validate({'packageName':payload['packageName'],'releases':payload['releases']});date(payload['issuedAtUtc'])
    if type(payload['sequence'])!=int or payload['sequence']<1 or len(raw)>90000 or len((ROOT/'updates-v2.json').read_bytes())>131072:raise ValueError('Invalid sequence or size.')
    executable=shutil.which('openssl') or next((str(p) for p in [Path('C:/Program Files/Git/usr/bin/openssl.exe'),Path('C:/Program Files/Git/mingw64/bin/openssl.exe')] if p.is_file()),None)
    if not executable:raise RuntimeError('OpenSSL is needed for the independent CI signature verification. The PowerShell publisher also verifies with .NET.')
    with tempfile.TemporaryDirectory(prefix='datacraft-public-verify-') as folder:
        p=Path(folder);(p/'payload').write_bytes(raw);(p/'signature').write_bytes(sig)
        subprocess.run([executable,'dgst','-sha256','-verify',str(ROOT/'publisher-public-key.pem'),'-signature',str(p/'signature'),str(p/'payload')],check=True)
    print(json.dumps({'signature':'Valid','sequence':payload['sequence'],'releases':len(payload['releases']),'payloadSHA256':hashlib.sha256(raw).hexdigest()}))
if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--build');parser.add_argument('--sequence',type=int);parser.add_argument('--verify',action='store_true');args=parser.parse_args()
    if args.build:build(args.build,args.sequence)
    elif args.verify:verify()
    else:validate(load(ROOT/'releases.json'));print('Release source valid.')
