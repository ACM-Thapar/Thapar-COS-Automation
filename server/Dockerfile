#pulling official node image
FROM node:alpine

# set workdir
WORKDIR "/app"

# copy package.json & yarn.lock
COPY package.json .
COPY package-lock.json .

# install dependencies
RUN npm install

# copy other files/directories
COPY . .

EXPOSE 5000

CMD ["npm" , "run" ,"start"]
