(indeces "stx.parse.test.Suite")
("json"
    include (
      ("stx.parse.term.json.Test"
        include
        "test_simple"
      )
    )
)
(
  "bootstrap"
    include (
      ("stx.parse.test.PositionTest" include "test")
    )
)
