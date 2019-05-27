RSpec.describe TallyCall do
  describe ".merge_reports" do
    it "returns the same report for a single report" do
      merged = TallyCall.merge_reports(
        { "Klass" => { "method_1" => 1, "method_2" => 2} }
      )

      expect(merged).to eq({ "Klass" => { "method_1" => 1, "method_2" => 2 } })
    end

    it "aggregates the same methods for the same class" do
      merged = TallyCall.merge_reports(
        { "Klass" => { "method_1" => 1, "method_2" => 2} },
        { "Klass" => { "method_1" => 4, "method_3" => 3} }
      )

      expect(merged).to eq(
        { "Klass" => { "method_1" => 5, "method_2" => 2, "method_3" => 3 } }
      )
    end
  end
end
