# R API
To create a working RESTful API using [R language][r] with [plumber][plumber] library on local machine or can be hosted on [Heroku][heroku].

## Getting Started
The instructions below will let you run the project up and running on your own local machine for development and testing purposes. For deployment, can refer to deployment section to understand how to deploy on a live system.

### Installation
You will need to install 1 library in R.
```
install.packages("plumber")
```

### Usage
You will need to define your R function with the plumber special comment.
```
## plumber.R

#' @post /function_a
function(a) {
  return(as.numeric(a)**2)
}
```
And on the other .R file or R console, can just type the following to allow the function become an API endpoint:
```
library(plumber)
pr <- plumb("plumber.R")
pr$run(port=8000)
```
After the function become an API, you can call it using [cURL][curl] as followed:
```
curl --data 'a=2' 'http://127.0.0.1:8000/function_a'
```

## Deployment
For deployment, there are many ways but in this project, we will be using Heroku to deploy the API.

### Prerequisites

#### Heroku
1. You will need to visit www.heroku.com and create an account.
2. You will need to download and setup Heroku CLI on your local machine. You may refer to this [link][heroku cli]. You will need to use this CLI to interact with Heroku and setup.
3. You will need to login to Heroku using the command ```heroku login```.

#### Plumber
You will need to have several .R scripts in order to make sure everything works fine.
The init.R is to initialize the API with libraries that you will used in your API.
```
# init.R
my_packages <- c("plumber")

install_if_missing <- function(p) {
  if(p %in% rownames(installed.packages())==FALSE){
    install.packages(p)}
}

invisible(sapply(my_packages, install_if_missing))
```
The plumber.R is your function as API. The file name must be plumber.R as it is required by Heroku.
```
# plumber.R
#' @post /function_a
function(a) {
  return(as.numeric(a)**2)
}
```
The app.R is the file that Heroku will run and initialize the plumber.
```
# app.R
library(plumber)

port <- Sys.getenv('PORT')
server <- plumb("plumber.R")
server$run(
  host = '0.0.0.0',
  port = as.numeric(port)
)
```

### Installation
1. You need to ```cd``` to your API directory which will be push to Heroku repository.
2. You will need to run the following codes to add the scripts to git:
```
- git init
- git add .
- git commit -m "My first commit"
```
3. You will need to type the following command in order to create a repository on Heroku and be able to use R language:
```
heroku create YOUR_APP_NAME --stack=heroku-18 --buildpack=https://github.com/virtualstaticvoid/heroku-buildpack-r.git
```
This [buildpack][buildpack] is what makes Heroku able to run R language.

4. The last step to push the scripts to Heroku:
```
git push heroku master
```

After you have setup everything, you should be able to call your API as followed:
```
curl --data 'a=2' 'https://YOUR_APP_NAME.herokuapp.com/function_a'
```

Other than cURL, you can actually use other languages to access the API. For this project, I will use Python as an example to call the API.
```
import requests

url = "https://YOUR_APP_NAME.herokuapp.com/function_a"
data = {
	"a": 2
}
response = requests.post(url = url, data = data)
```

[r]: https://www.r-project.org
[plumber]: https://www.rplumber.io
[heroku]: https://www.heroku.com
[curl]: https://curl.se
[heroku cli]: https://devcenter.heroku.com/articles/heroku-cli
[buildpack]: https://github.com/virtualstaticvoid/heroku-buildpack-r.git
