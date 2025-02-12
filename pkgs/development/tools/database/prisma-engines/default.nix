{ fetchFromGitHub
, lib
, Security
, openssl
, pkg-config
, protobuf
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "prisma-engines";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "prisma-engines";
    rev = version;
    sha256 = "sha256-c4t7r9Os0nmQEBpNeZ+XdTPc/5X6Dyw0dd7J4pw5s88=";
  };

  # Use system openssl.
  OPENSSL_NO_VENDOR = 1;

  cargoSha256 = "sha256-rjqFEY7GXXWzlw5E6Wg4KPz25BbvQPuLW5m8+3CbcRw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    protobuf
  ] ++ lib.optionals stdenv.isDarwin [ Security ];

  preBuild = ''
    export OPENSSL_DIR=${lib.getDev openssl}
    export OPENSSL_LIB_DIR=${openssl.out}/lib

    export PROTOC=${protobuf}/bin/protoc
    export PROTOC_INCLUDE="${protobuf}/include";

    export SQLITE_MAX_VARIABLE_NUMBER=250000
    export SQLITE_MAX_EXPR_DEPTH=10000
  '';

  cargoBuildFlags = "-p query-engine -p query-engine-node-api -p migration-engine-cli -p introspection-core -p prisma-fmt";

  postInstall = ''
    mv $out/lib/libquery_engine${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libquery_engine.node
  '';

  # Tests are long to compile
  doCheck = false;

  meta = with lib; {
    description = "A collection of engines that power the core stack for Prisma";
    homepage = "https://www.prisma.io/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pamplemousse pimeys ];
  };
}
