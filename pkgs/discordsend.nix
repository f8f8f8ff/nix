{ fetchFromGitHub, buildGoModule }:

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
    hash = "sha256-MbOkoEfOVHVLnXWCx1DSAewXXF0Qqnk8nMh3cu/Lgbg=";
  };

  vendorHash = null;
}
