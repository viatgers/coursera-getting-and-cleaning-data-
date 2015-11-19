##Definim els dos paths de treball de la carpeta de Test i train 
adress1<-"C:/Users/Joan/Dropbox/Personal Joan/Formacio/Johns Hopkins/Getting and Cleaning Data/Course Project/UCI HAR Dataset/test"
adress2<-"C:/Users/Joan/Dropbox/Personal Joan/Formacio/Johns Hopkins/Getting and Cleaning Data/Course Project/UCI HAR Dataset/train"
adress3<-"C:/Users/Joan/Dropbox/Personal Joan/Formacio/Johns Hopkins/Getting and Cleaning Data/Course Project/UCI HAR Dataset/"

## Pas 1: Merges the training and the test sets to create one data set.
## Fixem directori de test
setwd(adress1)

## Lleguim les fitxers de test i creem el data set de test
test = read.csv("X_test.txt", sep="", header=FALSE)
##Afegim una nova columna
test[,562] = read.csv("y_test.txt", sep="", header=FALSE)
##Afegim la darrera columna
test[,563] = read.csv("subject_test.txt", sep="", header=FALSE)

## Fixem directori de train
setwd(adress2)
## Lleguim les fitxers de train i creem el data set de train
train = read.csv("X_train.txt", sep="", header=FALSE)
##Afegim una nova columna
train[,562] = read.csv("y_train.txt", sep="", header=FALSE)
##Afegim la darrera columna
train[,563] = read.csv("subject_train.txt", sep="", header=FALSE)

one_data_set <- rbind(test,train)
## Fi del pas 1, ja tenim el data set resultant

## Pas 2, 2.Extracts only the measurements on the mean and standard deviation for each measurement
## Carreguem noms de les columnes
setwd(adress3)
noms_cols <- read.csv("features.txt", sep="", header=FALSE)

## Col·loquem el nom de les columnes al one_data_set
##colnames(one_data_set,do.NULL = FALSE)
names(one_data_set) <- c(noms_cols$V2, "Activity", "Subject")

## Identifiquem els números de les columnes de "X" que ens interessen
## La funció grep ens permet quedarnos amb totes les files de la columna número 2 que tinguin *PARAULA_CERCADA*, et retorna la primera columna!
num_cols_X_volem <- grep(".*-mean.*|.*-std.*", noms_cols[,2])
## Afegim la columna "Y" i la columna "subject" sobre 
num_cols_volem <- c(num_cols_X_volem,562,563)
## Un cop tenim clares les columnes que volem, apliquem sobre one_data_set la restricció del num_cols_ 
one_data_set<- one_data_set[,num_cols_volem]
## Fi del pas 2, ja tenim el subset de dades resultant d'aplicar la restricció de mean i std

## Pas3, Uses descriptive activity names to name the activities in the data set
## Carreguem activity labels
activity_labels <- read.csv("activity_labels.txt", sep="", header=FALSE)

## Definim el contador d'activitats (i) i l'inicialitzem a 1
i = 1 
## Entrem en bucle dins del activity_labels, la descripció
for (j in activity_labels$V2) { 
    one_data_set$Activity <- gsub(i, j, one_data_set$Activity) 
    i <- i + 1 
} 

## Final pas 4

##PAS 5, 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
one_data_set$Activity <- as.factor(one_data_set$Activity) 
one_data_set$Subject <- as.factor(one_data_set$Subject) 
tidy_data = aggregate(one_data_set, by=list(Activity = one_data_set$Activity, subject=one_data_set$Subject), mean)
# Treiem les darreres dues columnes del tidy_data ja que no tenen sentit
tidy_data[,90] = NULL 
tidy_data[,89] = NULL 
write.table(tidy_data, "tidy_data.txt", sep="\t") 
