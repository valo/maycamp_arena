require 'date'

def nyselect_date(date, options ={})
  id_prefix = id_prefix_for(options)
  select date.year, :from => "#{id_prefix}_#{DATE_TIME_SUFFIXES[:year]}"
  select date.strftime('%B'), :from => "#{id_prefix}_#{DATE_TIME_SUFFIXES[:month]}"
  select date.day, :from => "#{id_prefix}_#{DATE_TIME_SUFFIXES[:day]}"
end

def id_prefix_for(options = {})
  # msg = "cannot select option, no select box with id, name, or label '#{options[:from]}' found"
  find("label", :text => options[:from])['id'].gsub(/_#{DATE_TIME_SUFFIXES[:year]}$/,'')
end

When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" datetime$/ do |d, date_label|
  select_datetime(d, :from => date_label)
end

DATE_TIME_SUFFIXES = {
  :year   => '1i',
  :month  => '2i',
  :day    => '3i',
  :hour   => '4i',
  :minute => '5i'
}
