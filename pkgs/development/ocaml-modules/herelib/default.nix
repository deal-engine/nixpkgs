{lib, buildOcaml, fetchurl}:

buildOcaml rec {
  version = "112.35.00";
  pname = "herelib";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchurl {
    url = "https://github.com/janestreet/herelib/archive/${version}.tar.gz";
    sha256 = "03rrlpjmnd8d1rzzmd112355m7a5bwn3vf90xkbc6gkxlad9cxbs";
  };

  meta = with lib; {
    homepage = "https://github.com/janestreet/herelib";
    description = "Syntax extension for inserting the current location";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
