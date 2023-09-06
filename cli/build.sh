echo "++++++ Running ... /opt/homebrew/bin/python3.8 -m venv .venv "
/opt/homebrew/bin/python3.8 -m venv .venv

echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++ Running ... source .venv/bin/activate"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
source .venv/bin/activate

echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++ Running ... pip install -r requirements.txt "
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
pip install -r requirements.txt

echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++ Running pip install -r requirements-dev.txt"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
pip install -r requirements-dev.txt

echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++ Running ... pip install -e ."
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
pip install -e .

echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++ Running ... pip install aws-codeseeder"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
# pip install aws-codeseeder
pip install -e /Users/santhosh.karuhatty/workspace/aws-codeseeder/

# copy aws-codeseeder to the workbench directory
echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++ Copying ... cp -R /Users/santhosh.karuhatty/workspace/aws-codeseeder /Users/santhosh.karuhatty/workspace/aws-orbit-workbench "
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
cp -R /Users/santhosh.karuhatty/workspace/aws-codeseeder /Users/santhosh.karuhatty/workspace/aws-orbit-workbench

echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++ Running ... codeseeder deploy seedkit orbit"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
# codeseeder deploy seedkit orbit
/Users/santhosh.karuhatty/workspace/aws-orbit-workbench/cli/.venv/bin/codeseeder deploy seedkit orbit

echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++ Running orbit init -n "sky-orbit-env" -r us-east-1"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
orbit init -n "sky-orbit-env" -r us-east-1 --debug
cp -R /Users/santhosh.karuhatty/default-env-manifest.yaml conf/

echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++ Running orbit deploy toolkit -f conf/default-env-manifest.yaml"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
orbit deploy toolkit -f conf/default-env-manifest.yaml --debug

echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++ Running orbit deploy images -f conf/default-env-manifest.yaml"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#orbit deploy images -f conf/default-env-manifest.yaml --debug

echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++ Running orbit deploy env -f conf/default-env-manifest.yaml"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
orbit deploy env -f conf/default-env-manifest.yaml --debug