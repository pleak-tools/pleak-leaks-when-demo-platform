Clone demo repository using this command:

git clone -b dev --recurse-submodules https://github.com/pleak-tools/pleak-leaks-when-demo-platform

Then run:


cd pleak-leaks-when-demo-platform

sudo docker build -t pleaktools/leakswhen .

sudo docker run --rm -it -p 8080:8080 -p 8000:8000  pleaktools/leakswhen



After this run:

git clone https://github.com/pleak-tools/pleak-leaks-when-ast-transformation.git

cd pleak-leaks-when-ast-transformation

sudo docker build -t pleaktools/leakswhen-b .

sudo docker run --rm -it -p 3000:3000 pleaktools/leakswhen-b



Then application is accessible through

http://localhost:8000
