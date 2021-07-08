# Comcast-Telecom-Consumer-Complaints.
Comcast Telecom Consumer Complaints by R

### DESCRIPTION

Comcast is an American global telecommunication company. The firm has been providing terrible customer service. They continue to fall short despite repeated promises to improve. Only last month (October 2016) the authority fined them a $2.3 million, after receiving over 1000 consumer complaints.

The existing database will serve as a repository of public customer complaints filed against Comcast.
It will help to pin down what is wrong with Comcast's customer service.

### Data Dictionary

  1. Ticket #: Ticket number assigned to each complaint
  2. Customer Complaint: Description of complaint
  3. Date: Date of complaint
  4. Time: Time of complaint
  5. Received Via: Mode of communication of the complaint
  6. City: Customer city
  7. State: Customer state
  8. Zipcode: Customer zip
  9. Status: Status of complaint
  10. Filing on behalf of someone

### Analysis Task

- Import data into R environment.
- Provide the trend chart for the number of complaints at monthly and daily granularity levels.
- Provide a table with the frequency of complaint types.

Which complaint types are maximum i.e., around internet, network issues, or across any other domains.
- Create a new categorical variable with value as Open and Closed. Open & Pending is to be categorized as Open and Closed & Solved is to be categorized as Closed.
- Provide state wise status of complaints in a stacked bar chart. Use the categorized variable from Q3. Provide insights on:

Which state has the maximum complaints
Which state has the highest percentage of unresolved complaints
- Provide the percentage of complaints resolved till date, which were received through theInternet and customer care calls.
