default: test-interp
unit:
  clear && hx build unit
test-interp:
  clear && hx build test/interp
test-json-interp:
  clear && hx build json/test/interp
test-json-interp-build:
  clear && STX_TEST__SUITE=poke hx build json/test/interp