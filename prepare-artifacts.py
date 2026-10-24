"""Prepare public artifact hashes from the exact signed itch ZIP; never publish its bytes or local path."""
from pathlib import Path
import argparse, base64, datetime, hashlib, io, json, re, subprocess, tempfile, tarfile, zipfile
import importlib.util
ROOT=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('datacraft_public_channel',ROOT/'build-channel.py')
channel=importlib.util.module_from_spec(spec);spec.loader.exec_module(channel)
MARKER='DataCraft.UpdateArtifacts'

def validate(data):
    channel.keys(data,'packageName artifacts')
    if data['packageName']!='dev.amedina.datacraft' or not isinstance(data['artifacts'],list) or len(data['artifacts'])>48:raise ValueError('Invalid artifact source.')
    versions=set()
    for row in data['artifacts']:
        channel.keys(row,'version store filename bytes sha256 tarballFilename tarballSha256')
        if row['store']!='itch' or row['version'] in versions:raise ValueError('Invalid store or duplicate artifact version.')
        channel.version(row['version']);versions.add(row['version'])
        if type(row['bytes'])!=int or not 0<row['bytes']<=512*1024*1024:raise ValueError('Invalid archive size.')
        for name,extension in [('filename','.zip'),('tarballFilename','.tgz')]:
            value=row[name]
            if not isinstance(value,str) or len(value)>180 or not re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9._-]*',value) or not value.endswith(extension):raise ValueError('Unsafe artifact filename.')
        for name in ['sha256','tarballSha256']:
            if not isinstance(row[name],str) or not re.fullmatch('[a-f0-9]{64}',row[name]):raise ValueError('Invalid artifact SHA-256.')
    return sorted(data['artifacts'],key=lambda r:channel.version(r['version']),reverse=True)

def add(archive):
    path=Path(archive);size=path.stat().st_size
    if not 0<size<=512*1024*1024:raise ValueError('Archive exceeds the client limit.')
    with zipfile.ZipFile(path) as z:
        if len(z.infolist())>64:raise ValueError('Too many ZIP entries.')
        for info in z.infolist():
            if '\\' in info.filename or info.filename.startswith('/') or ':' in info.filename or any(p in ['.','..'] for p in info.filename.split('/')):raise ValueError('Unsafe ZIP path.')
        members=[p for p in z.infolist() if p.filename.endswith('.tgz')]
        if len(members)!=1 or members[0].file_size>512*1024*1024:raise ValueError('Exactly one signed tarball required.')
        raw=z.read(members[0])
    with tarfile.open(fileobj=io.BytesIO(raw),mode='r:gz') as t:
        names=[m.name for m in t if m.isfile()]
        if names.count('package/package.json')!=1 or names.count('package/Editor/UpdateDistribution.json')!=1 or names.count('package/.attestation.p7m')!=1:raise ValueError('Signed package identity is missing or duplicated.')
        for name in ['package/package.json','package/Editor/UpdateDistribution.json']:
            if t.getmember(name).size>65536:raise ValueError('Package metadata too large.')
        manifest=json.load(t.extractfile('package/package.json'));edition=json.load(t.extractfile('package/Editor/UpdateDistribution.json'))
    if manifest['name']!='dev.amedina.datacraft' or edition!={'format':'DataCraft.Distribution','formatVersion':1,'edition':'itch'}:raise ValueError('This is not the official itch.io edition.')
    releases=channel.validate(channel.load(ROOT/'releases.json'))
    release=next((r for r in releases if r['version']==manifest['version']),None)
    if not release or not release['stores']['itch']:raise ValueError('Publish and verify this exact version on itch.io, then mark its availability before announcing the artifact.')
    row={'version':manifest['version'],'store':'itch','filename':path.name,'bytes':size,'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'tarballFilename':Path(members[0].filename).name,'tarballSha256':hashlib.sha256(raw).hexdigest()}
    source=channel.load(ROOT/'artifacts.json');source['artifacts']=[r for r in source['artifacts'] if r['version']!=row['version']]+[row];source['artifacts']=validate(source)
    temp=ROOT/'artifacts.json.tmp';temp.write_text(json.dumps(source,indent=2)+'\n',encoding='utf-8');temp.replace(ROOT/'artifacts.json')
    print(json.dumps({'version':row['version'],'filename':row['filename'],'sha256':row['sha256']}))

def build(output,sequence):
    if sequence<1:raise ValueError('Positive artifact sequence required.')
    source=channel.load(ROOT/'artifacts.json');rows=validate(source)
    releases=channel.validate(channel.load(ROOT/'releases.json'))
    if any(not any(r['version']==a['version'] and r['stores']['itch'] for r in releases) for a in rows):raise ValueError('Every downloadable artifact must be actually released on itch.io.')
    payload={'packageName':source['packageName'],'sequence':sequence,'issuedAtUtc':datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'),'artifacts':rows}
    raw=json.dumps(payload,ensure_ascii=False,separators=(',',':')).encode('utf-8')
    if len(raw)>90000:raise ValueError('Artifact metadata exceeds its client limit.')
    Path(output).write_bytes(raw)

def verify():
    outer=channel.load(ROOT/'artifacts-v1.json');channel.keys(outer,'format formatVersion keyId payload signature')
    if outer['format']!=MARKER or outer['formatVersion']!=1 or outer['keyId']!='publisher-2026-10':raise ValueError('Unknown artifact envelope.')
    raw=base64.b64decode(outer['payload'],validate=True);signature=base64.b64decode(outer['signature'],validate=True)
    value=json.loads(raw.decode('utf-8'),object_pairs_hook=channel.unique);channel.keys(value,'packageName sequence issuedAtUtc artifacts');validate({'packageName':value['packageName'],'artifacts':value['artifacts']});channel.date(value['issuedAtUtc'])
    if type(value['sequence'])!=int or value['sequence']<1 or len(raw)>90000 or len((ROOT/'artifacts-v1.json').read_bytes())>131072:raise ValueError('Invalid artifact sequence/size.')
    import shutil
    openssl=shutil.which('openssl') or next((str(p) for p in [Path('C:/Program Files/Git/usr/bin/openssl.exe'),Path('C:/Program Files/Git/mingw64/bin/openssl.exe')] if p.is_file()),None)
    if not openssl:raise RuntimeError('OpenSSL required for independent verification.')
    with tempfile.TemporaryDirectory(prefix='datacraft-artifacts-verify-') as folder:
        p=Path(folder);(p/'payload').write_bytes(raw);(p/'signature').write_bytes(signature);subprocess.run([openssl,'dgst','-sha256','-verify',str(ROOT/'publisher-public-key.pem'),'-signature',str(p/'signature'),str(p/'payload')],check=True)
    print(json.dumps({'artifactSignature':'Valid','sequence':value['sequence'],'artifacts':len(value['artifacts'])}))

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--add');parser.add_argument('--build');parser.add_argument('--sequence',type=int);parser.add_argument('--verify',action='store_true');args=parser.parse_args()
    if args.add:add(args.add)
    elif args.build:build(args.build,args.sequence)
    elif args.verify:verify()
    else:parser.error('Choose --add, --build or --verify.')
