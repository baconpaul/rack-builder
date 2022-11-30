#!/bin/zsh

RACK_HASH=6a292c41923fb9951d85248c7930386b39a1a555

if [[ ! -d build ]];
then
  mkdir build
fi
pushd build
if [[ ! -d Rack ]];
then
  git clone https://github.com/vcvrack/Rack
  pushd Rack
  git checkout ${RACK_HASH}
  git submodule update --init --recursive 
  git apply ../../source.patch
else
  pushd Rack
fi

make dep
make -j

pushd plugins

make_plug() {
   gh=$1
   rp=$2
   echo "https://github.com/$gh/$rp"
   if [[ ! -d $rp ]];
   then
      git clone https://github.com/$gh/$rp
      pushd $rp
      git submodule update --init --recursive
   else
      pushd $rp
   fi
   
   make dep
   make -j dist
   cp dist/*.vcvplugin ~/Documents/Rack2/plugins_arm64
   popd 
}

mkdir -p ~/Documents/Rack2/plugins_arm64
make_plug baconpaul BaconPlugs
make_plug countmodula VCVRackPlugins
make_plug MarcBoule ImpromptuModular
make_plug MarcBoule MindMeldModular
make_plug bogaudio BogAudioModules
make_plug surge-synthesizer surge-rack
make_plug VCVRack Befaco
make_plug VCVRack Fundamental
popd

make dist
mv dist/VCV\ Rack\ 2\ Arm\ Modified.app ~/Desktop

popd
popd

echo "Rack on Desktop is good to go"




