#Handsize Dataset, which is to be used to see if we can predict the height
#Dataset was gotten from this site http://serc.carleton.edu/sp/cause/cooperative/examples/18172.html
#From web findings the dataset belongs to Prof. Carl Lee and Prof. Felix Famoye. 
#Just trying to be on the safe side.. hahahaha

#Kickoff
#Loading the Dataset
data = read.csv('C:/Users/Gabrielahrlr/Desktop/Data Science Specialization/Regression/boss.csv',header=TRUE)

#Structure of the data
str(data)

#Features like user_type wouldnt be used because it has no use, so we take it out
new_data = data[,2:5]
str(new_data)

#Summary of the Data 
summary(new_data)

#50 observations , 26 females, 24 males, I dont know the measurement scales\
#for the handlenght,handwidth and height will be inches too , I am guessing it will be inches 

#Anyways time to Visualize thingsssss
#for Gender
gender = new_data$Gender
gender= table(gender)
color= c('pink','blue')
barplot(gender, col=color, ylim=c(0,40),xpd=FALSE)

#for handlength, handwidth and height
handlength= new_data$hand_length
handwidth= new_data$hand_width
height= new_data$height
range(handlength)
hist(handlength, col='#ddee22')
hist(handwidth,col='#aabb11')
hist(height,col='#EEAA44')

#To see everything as A first step in EDA
panel.cor <- function(x, y, digits=2, prefix="", cex.cor, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits=digits)[1]
  txt <- paste(prefix, txt, sep="")
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}
pairs(new_data[,2:4],col=new_data$Gender, lower.panel=panel.smooth,upper.panel=panel.cor)

#Just to Verify
cor(exp(handlength),height)
cor(exp(handwidth),height)
maleHandlength=subset(new_data,Gender=='male')
maledata=maleHandlength
pairs(maledata[,2:4], lower.panel=panel.smooth,upper.panel=panel.cor)

#Fitting the Model Multilinear Regression
fit <- lm(height~ exp(hand_length)+exp(hand_width)+Gender, data=new_data)
summary(fit)
plot(fit)

#Normalize
normalize <- function(x) {
  num <- x - min(x)
  denom <- max(x) - min(x)
  return (num/denom)
}
range(new_data$hand_length)
range(new_data$hand_width)
nhl<- as.data.frame(lapply(new_data$hand_length, normalize))
nhw<- as.data.frame(lapply(new_data$hand_width, normalize))
breaksHW <- seq(4.00,12.00, by=1)
breaksHW
breaksHL <- seq(5.00,9.00, by=1)
breaksHL
hl.cut=cut(new_data$hand_length,breaksHL,right=FALSE)
hl.cut
midhl = new_data$hand_length - mean(new_data$hand_length )
midhw = new_data$hand_width - mean(new_data$hand_width)
interaction_effect = midhl * midhw
hw.cut=cut(new_data$hand_width,breaksHW,right=FALSE)
hw.cut
midnhl=nhl-mean(nhl)
midnhw=nhw-mean(nhw)
intdata=midnhl*midnhw
table(hw.cut)
fit <- lm(height~ nhl+nhw+Gender, data=new_data)
summary(fit)
fit <- glm(height~ exp(hand_length)+exp(hand_width)+exp(interaction_effect)+as.numeric(Gender), data=new_data)
summary(fit)
anova(fit)

###########

# Other useful functions 
coefficients(fit) # model coefficients
confint(fit, level=0.95) # CIs for model parameters 
fitted(fit) # predicted values
residuals(fit) # residuals
anova(fit) # anova table 
vcov(fit) # covariance matrix for model parameters 
influence(fit) # regression diagnostics

##########


fit1 <- lm(height~hand_length, data=new_data)
summary(fit1)

#Sampling
mysample <- new_data[sample(1:nrow(new_data), 1000,
                          replace=TRUE),]

fit2 <- lm(height~exp(hand_length)+exp(hand_width)+Gender, data=mysample)
summary(fit2)