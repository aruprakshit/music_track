module Query
  class DailyReport
    def initialize args = {}
      @start_date = args[:start_date]
      @end_date   = args[:end_date]
      @labels     = args[:labels]
    end

    def build_sql
      sql =<<-QUERY
SELECT dense_rank() over (order by count(events.id) desc) AS "Ranking" ,tracks.isrc AS "ISRC", tracks.title AS "Track Name", tracks.artist AS "Artist Name" , tracks.label AS "Label", count(events.id) AS "Quantity" from tracks INNER JOIN events ON tracks.apple_id = events.apple_id WHERE ( start_date BETWEEN '#{@start_date}' AND '#{@end_date}' ) AND label IN (#{@labels}) GROUP BY tracks.apple_id HAVING count(events.id) > 0 ORDER BY "Quantity" DESC LIMIT 50
      QUERY
    end
  end
end
