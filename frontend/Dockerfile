FROM nginx:latest 

COPY index.html /usr/share/nginx/html/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
   CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1