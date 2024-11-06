{ fetchFromGitHub , buildGoModule }:

let
  version = "87dc679";
in
buildGoModule {
  pname = "discordsend";
  inherit version;

  src = fetchFromGitHub {
    owner = "f8f8f8ff";
    repo = "discord";
    rev = version;
    hash = "sha256-X4vMwp5CWGqNLwBDC7hl4C1H1JKrZVAzLM0AmQMtJ9Q=";
  };

  vendorHash = null;
}
