{ lib, buildGoModule, fetchFromGitHub, pkg-config, glib, gobject-introspection, gst_all_1 }:

buildGoModule rec {
  pname = "livekit-ingress";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "ingress";
    rev = "v${version}";
    hash = "sha256-d5H8MEVL0xNyzufV1lKLu3TS/usw5bCPlfXAjdcqhII=";
  };

  nativeBuildInputs = [ pkg-config glib.dev gobject-introspection.dev ];
  buildInputs = [ gst_all_1.gstreamer.dev gst_all_1.gst-plugins-base.dev ];

  vendorHash = "sha256-IPNRKXsSoTXVqq6pcp4QVepxim+7eDa8qh5b1No6DLE=";

  subPackages = [ "cmd/server" ];

  postInstall = ''
    mv $out/bin/server $out/bin/livekit-ingress
  '';

  meta = with lib; {
    description = "Ingress server for livekit server.";
    homepage = "https://livekit.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaron-nall ];
    mainProgram = "livekit-ingress";
  };
}
