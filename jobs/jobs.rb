
SCHEDULER.every '10s' do
  job_1 = { job_title: "Title 1", company: "Company 1", category: "Category 1", created: "some time" }
  job_2 = { job_title: "Title 2", company: "Company 2", category: "Category 2", created: "some time" }
  jobs = [job_1, job_2]

  send_event('jobs', { title: "Latest jobs", items: jobs })
end
