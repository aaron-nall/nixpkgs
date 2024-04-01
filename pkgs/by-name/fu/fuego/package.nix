{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fuego";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "sgarciac";
    repo = "fuego";
    rev = "${version}";
    hash = "sha256-CtkUJFvCmJ0xReWbKnYVhaN0b6aM6/4yERkYDl3/Axg=";
  };

  vendorHash = "sha256-UbhXyuQjWwgZfr2R6KtHj8gvXejW9nonu4HmDLD4aEg=";

  meta = with lib; {
    description = "A command-line firestore client.";
    homepage = "https://github.com/sgarciac/fuego";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaron-nall ];
    mainProgram = "fuego";
  };
}
