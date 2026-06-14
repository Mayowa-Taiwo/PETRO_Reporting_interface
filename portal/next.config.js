const path = require("path");

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  experimental: {
    externalDir: true,
  },
  webpack: (config) => {
    config.resolve.alias = {
      ...config.resolve.alias,
      "@tanna/theme": path.join(__dirname, "../packages/theme"),
      "@products": path.join(__dirname, "../products"),
    };
    return config;
  },
};

module.exports = nextConfig;
