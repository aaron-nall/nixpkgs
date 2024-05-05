{ lib, stdenv, fetchFromGitHub, cmake, obs-studio, onnxruntime, opencv, pkgs, curl }:

stdenv.mkDerivation rec {
  pname = "obs-backgroundremoval";
  version = "1.1.13";

  src = fetchFromGitHub {
    owner = "occ-ai";
    repo = "obs-backgroundremoval";
    rev = "${version}";
    hash = "sha256-QoC9/HkwOXMoFNvcOxQkGCLLAJmsja801LKCNT9O9T0=";
  };

  passthru.obsWrapperArguments =
    let
      obsBackgroundRemovalHook = package: "--prefix LD_PRELOAD : ${lib.getLib package}/lib/libonnxruntime.so.1.16.3";
    in
    builtins.map obsBackgroundRemovalHook [
      onnxruntime
    ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio onnxruntime opencv curl];

  dontWrapQtApps = true;

  cmakeFlags = [
    "--preset linux-x86_64"
    "-DCMAKE_MODULE_PATH:PATH=${src}/cmake"
    "-DUSE_SYSTEM_ONNXRUNTIME=ON"
    "-DUSE_SYSTEM_OPENCV=ON"
    "-DDISABLE_ONNXRUNTIME_GPU=ON"
  ];
  postPatch = ''
    substituteInPlace CMakeLists.txt \
        --replace-fail "Onnxruntime" "onnxruntime"
  '';

  meta = with lib; {
    description =
      "OBS plugin to replace the background in portrait images and video";
    homepage = "https://github.com/royshil/obs-backgroundremoval";
    maintainers = with maintainers; [ zahrun aaron-nall ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
  };
}
