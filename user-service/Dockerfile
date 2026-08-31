FROM node:20-alpine

# Creating a non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy the application code
COPY --chown=nodejs:nodejs server.js .

# Switch to the non-root user
USER nodejs

ENV PORT=3001

EXPOSE 3001

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
   CMD wget --quiet --tries=1 --spider http://localhost:3001/health || exit 1

CMD ["node" , "server.js"]