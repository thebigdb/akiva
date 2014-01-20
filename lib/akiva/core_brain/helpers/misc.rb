module Akiva
  module Brain
    module Helpers

      def self.degroup_multiple_values(string)
        # NOTE: we probably should check the dictionary here to improve the values detections,
        # and limit the number of requests made.
        values = []

        string.split(" && ").each do |sub0|
          sub0.split(",").each do |sub1|
            sub1.split(" and ").each do |sub2|
              val = sub2.strip
              val.gsub!(/\A(a|an|the) /i, "")
              values << val
            end
          end
        end

        values.uniq
      end

      def self.cleanup_articles(string)
        string.gsub(/\A(a|an|the) /i, "")
      end
    end
  end
end