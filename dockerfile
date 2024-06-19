#stage 1: Build the Node.js application
FROM node:14 AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY ./node-hello/package*.json ./

# Install dependencies
RUN npm install

# Copy application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Create a minimal production image
FROM node:14-alpine

# Set working directory
WORKDIR /app

# Copy build output from the previous stage
COPY --from=build /app .
COPY --from=build /app/package*.json ./

# Install only production dependencies
RUN npm install --only=production

# Expose the port on which the app runs (adjust if necessary)
EXPOSE 3000

# Command to run the application
CMD ["node", "./dist/server.js"]

