{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "livekit-ingress";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "ingress";
    rev = "v${version}";
    hash = "sha256-2MooX+wy7KetxEBgQoVoL4GuVkm+SbTzYgfWyLL7KU8=";
  };

  vendorHash = "sha256-8YR0Bl+sQsqpFtD+1GeYaydBdHeM0rRL2NbgAh9kCj0=";

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
