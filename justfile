default: test-interp
unit:
  clear && hb build unit
test-interp:
  clear && hb build test/interp
test-json-interp:
  clear && hb build json/test/interp
test-json-interp-build:
  clear && STX_TEST__SUITE=poke hb build json/test/interp