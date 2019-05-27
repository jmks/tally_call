require "tally_call/version"
require "tally_call/trace"

module TallyCall
  def self.merge_reports(*reports)
    reports.each_with_object({}) do |report, merged|
      report.each_pair do |class_name, method_counts|
        merged[class_name] ||= {}

        merged[class_name].update(method_counts) do |_, count_1, count_2|
          count_1 + count_2
        end
      end
    end
  end
end
