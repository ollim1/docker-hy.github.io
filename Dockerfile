FROM jekyll/jekyll:3.8.3 as build-stage

WORKDIR /tmp

COPY Gemfile* ./

RUN bundle install

WORKDIR /usr/src/app

COPY . .

RUN chown -R jekyll .

RUN jekyll build

FROM nginx:alpine

COPY --from=build-stage /usr/src/app/_site/ /usr/share/nginx/html

COPY nginx.conf /;etc/nginx/conf.d/default.conf

CMD sed -i 's/PORT/'"$PORT"'/' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
