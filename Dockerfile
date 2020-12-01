# build environment
#docker build -t fe .
# docker create -p 8085:8085 --name fectr fe

FROM node:12.2.0-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package*.json /app/
RUN npm install --silent
RUN npm install @vue/cli@3.7.0 -g
COPY . /app
RUN npm run build

FROM nginx:1.16.0-alpine
COPY --from=build /app/dist /usr/share/nginx/html/dist
COPY --from=build /app/startsite.sh /usr/share/nginx/html/dist
RUN chmod +x /usr/share/nginx/html/dist/startsite.sh

RUN rm /etc/nginx/nginx.conf
COPY nginx/nginx.conf* /etc/nginx/

ENV tls_bypass=true 

# cert and key
#RUN mkdir -p /etc/dwdataden.dev/conf
#COPY fullchain.pem /etc/xxxx/conf/fullchain.pem
#COPY privkey.pem /etc/xxxx/conf/privkey.pem

ENTRYPOINT ["/usr/share/nginx/html/dist/startsite.sh"]
