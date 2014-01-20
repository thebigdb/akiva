module AkivaStatementsHelpers

  def stub_statement(expected_query_sent, expected_statements_received)
    _in = hash_including(expected_query_sent)
    _out = JSON(status: "success", statements: expected_statements_received, total_results: expected_statements_received.size)
    # _out[:total_results] = expected_statements_received.size if expected_statements_received.is_a?(Array)

    stub_request(:get, /#{TheBigDB.api_host}\/v1\/statements\/search/)
      .with(query: _in)
      .to_return(body: _out)
  end

  def stub_statements(*ids)
    ids.each do |id|
      statement = STORED_STATEMENTS[id]
      stub_statement(statement[:query], statement[:response])
    end
  end

  STORED_STATEMENTS = {
    a0: {
      query: {nodes: {subject: "iPhone 5s", property: "weight"}, per_page: "1"},
      response: [{nodes: {subject: "iPhone 5s", property: "weight", answer: "112 grams"}}]
    },
    a1: {
      query: {nodes: {subject: "iPhone 5s", property: "weight and height"}, per_page: "1"},
      response: []
    },
    a2: {
      query: {nodes: {subject: "iPhone 5s", property: "height"}, per_page: "1"},
      response: [{nodes: {subject: "iPhone 5s", property: "height", answer: "123.8 mm"}}]
    },
    a3: {
      query: {nodes: {subject: "iPhone 5s and a Galaxy S4", property: "weight"}, per_page: "1"},
      response: []
    },
    a4: {
      query: {nodes: {subject: "Galaxy S4", property: "weight"}, per_page: "1"},
      response: [{nodes: {subject: "Galaxy S4", property: "weight", answer: "130 grams"}}]
    },
    a5: {
      query: {nodes: {subject: "iPhone 5s and a Galaxy S4", property: "weight and height"}, per_page: "1"},
      response: []
    },
    a6: {
      query: {nodes: {subject: "Galaxy S4", property: "height"}, per_page: "1"},
      response: [{nodes: {subject: "Galaxy S4", property: "height", answer: "136.6 mm"}}]
    },

    b0: {
      query: {nodes: {subject: "Director of Public Affairs and Communication", property: "salary"}, per_page: "1"},
      response: [{nodes: {subject: "Director of Public Affairs and Communication", property: "salary", answer: "$10,000"}}]
    },
    b1: {
      query: {nodes: {subject: "Director of Public Affairs and Communication", property: "salary and benefits"}, per_page: "1"},
      response: []
    },
    b2: {
      query: {nodes: {subject: "Director of Public Affairs and Communication", property: "benefits"}, per_page: "1"},
      response: [{nodes: {subject: "Director of Public Affairs and Communication", property: "benefits", answer: "Dental"}}]
    },



  }
end