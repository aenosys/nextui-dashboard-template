# Use the official Node.js image as the base image
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm run build

# Use nginx image to serve the static files
FROM nginx:alpine

# Copy the built files from the builder stage to the Nginx HTML directory
COPY --from=builder /app/out /usr/share/nginx/html

# Expose port 80 to serve the app
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
