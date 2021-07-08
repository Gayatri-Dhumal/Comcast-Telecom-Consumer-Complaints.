
#Import data into R environment.

getwd()
data = read.csv("Telecom.csv", header = T, stringsAsFactors = T)
View(data)
class(data)
str(data)

# Loading The Date Into Single Format

library(lubridate)
data$Date = parse_date_time(data$Date, orders = c('mdy', 'dmy','ymd'))
View(data$Date)
class(data$Date)
unique(data$Date)

data$Date = as.Date(data$Date)
View(data)
unique(data$Date)

# Check for missing data

na_vector <- is.na(data)
length(na_vector[na_vector==T])

# The trend chart for the number of complaints at monthly and daily granularity levels.

# Extracting Month Column and Converting to The labels. 

data$Month <- format(as.Date(data$Date), "%m")
data$Month <- month.abb[as.integer(data$Month)]
View(data)

# Analysing data

#1) Monthly Counts

library(dplyr)

monthly_count <- summarise(group_by(data,Month = as.integer(month(Date))),Count = n())
monthly_count <- arrange(monthly_count,Month)
monthly_count

plot(monthly_count, main = "monthly Counts", xlab = "Months", ylab = "Number of tickets", type = "b", col = "red" )

#2) Daily Counts

daily_count<- summarise(group_by(data,Date),Count =n())
daily_count
par(bg = 'White')
plot(daily_count, main = "Daily Counts", xlab = "Days", ylab = "Number of tickets", type = "b", col = "red" )

data$Month <- as.factor(data$Month)
levels(data$Month)

# Frequency Table For Customer Complaints

# Converting All String Values to Lower, so as to Eliminate Duplication of Any Complaint

data = data %>% mutate(Customer.Complaint = tolower(Customer.Complaint))
CustTable = table(data$Customer.Complaint)
CustTable = data.frame(CustTable)
filtered = CustTable %>% rename(CustomerComplaintType = Var1, Frequency = Freq)
final = filtered %>% arrange(desc(Frequency))
final

# Fetching The Top 20 complaints filled by customers on different days.

final_most = head(final,20)
View(final_most)

library(ggplot2)
ggplot(head(final_most,6), aes(CustomerComplaintType, Frequency)) +
  geom_bar(stat = "identity")

# Customer Are Mainly complaining about the Data Caps, Internet Speed, Billing Methods and Services
# that Comcast is Providing and Very few Cases were registered against Comcast Cable Services.

# Create a new categorical variable with value as Open and Closed.

levels(data$Status)

open_complaints = (data$Status == "Open"| data$Status =="Pending")
closed_complaints = (data$Status == "Closed"| data$Status =="Solved")
data$Complaint_Status[ open_complaints] = "Open" 
data$Complaint_Status[closed_complaints] = "Closed"

View(data)

# Provide state wise status of complaints in a stacked bar chart.

states_table = table(data$State,data$Complaint_Status)
states_table = cbind(states_table, Total = rowSums(states_table))
View(states_table)

data = group_by(data,State,Complaint_Status)
chart_data = summarise(data,Count = n())

ggplot(as.data.frame(chart_data) ,mapping = aes(State,Count))+
  geom_col(aes(fill = Complaint_Status),width = 0.95)+
  theme(axis.text.x = element_text(angle = 90),
        axis.title.y = element_text(size = 15),
        axis.title.x = element_text(size = 15),
        title = element_text(size = 16,colour = "#0073C2FF"),
        plot.title = element_text(hjust =  0.5))+
  labs(title = "Ticket Status Stacked Bar Chart ",
       x = "States",y = "No of Tickets",
       fill= "Status")

# Georgia and Florida are the Two where Comcast has a good number of Happy customers by 
# solving the issues.

# Finding State which has Highest number of Unresolved Tickets.

chart_data%>%
  filter(Complaint_Status == "Open")->
  open_complaints
open_complaints[open_complaints$Count == max(open_complaints$Count),c(1,3)]

# Finding state which has the highest percentage of unresolved complaints

resolved_data = group_by(data,Complaint_Status)
total_resloved = summarise(resolved_data ,percentage =(n()/nrow(resolved_data)))
total_resloved

# Pie chart for percentage of unresolved complaints

par(mfrow = c(1,2))
total = ggplot(total_resloved,
               aes(x= "",y =percentage,fill = Complaint_Status))+
  geom_bar(stat = "identity",width = 1)+
  coord_polar("y",start = 0)+
  geom_text(aes(label = paste0(round(percentage*100),"%")),
            position = position_stack(vjust = 0.5))+
  labs(x = NULL,y = NULL,fill = NULL)+
  theme_classic()+theme(axis.line = element_blank(),
                        axis.text = element_blank(),
                        axis.ticks = element_blank())

total

# the percentage of complaints resolved till date, which were received through 
# the Internet and customer care calls.

resolved_data = group_by(data,Received.Via,Complaint_Status)
Category_resloved = summarise(resolved_data ,percentage =(n()/nrow(resolved_data)))
Category_resloved


# Pie Chart for Category wise Ticket Status

category = ggplot(Category_resloved,
                 aes(x= "",y =percentage,fill = Complaint_Status))+
  geom_bar(stat = "identity",width = 1)+
  coord_polar("y",start = 0)+
  geom_text(aes(label = paste0(Received.Via,"-",round(percentage*100),"%")),
            position = position_stack(vjust = 0.5))+
  labs(x = NULL,y = NULL,fill = NULL)+
  theme_classic()+theme(axis.line = element_blank(),
                        axis.text = element_blank(),
                        axis.ticks = element_blank())
category



