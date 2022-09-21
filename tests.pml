(indeces "stx.parse.test.Suite")
("poke"
    include (
      ("stx.parse.term.json.Test"
        include
        "test_escaped_double_quotes"
      )
    )
)