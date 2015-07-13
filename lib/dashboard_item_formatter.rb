module DashboardItemFormatter

  def format_job(job_hash)
    display_labels = {
      "full_time" => "Full Time",
      "part_time" => "Part Time"
    }
    travel_time = TravelTimeFormatter.new(job_hash["travelling_time"].to_i).run
    result = {
      job_title: job_hash["title"],
      company: job_hash["company_name"],
      created: "Posted "+TimeHumanizer.new(DateTime.now, DateTime.parse(job_hash["created"])).run,
      category: job_hash["category"].sub(/Jobs$/, ''),
      contract_time: display_labels.fetch(job_hash["contract_time"], job_hash["contract_time"])
    }
    if travel_time
      result[:travelling_time] = "Approximately #{travel_time} away"
    end
    result
  end

  def format_category(category_hash)
    {
      "label" => category_hash["category"].sub(/Jobs$/, '')
    }
  end

  def format_company(company_hash)
    {
      "label" => company_hash["company_name"]
    }
  end

end
