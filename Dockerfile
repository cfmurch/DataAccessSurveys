FROM rocker/shiny:4.4.1

# -----------------------------
# Install system dependencies
# -----------------------------

RUN apt-get update && apt-get install -y \
    build-essential \
    g++ \
    gcc \
    make \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libicu-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libwebp-dev \
    libwebp7 \
    libwebpmux3 \
    libsodium-dev \
    libtool \
    libc-dev \
    libgomp1 \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    wkhtmltopdf \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------
# Enable renv cache
# -----------------------------
ENV RENV_CONFIG_CACHE_ENABLED="TRUE"

# -----------------------------
# GitHub PAT for private packages
# -----------------------------
ARG GITHUB_PAT
ENV GITHUB_PAT=${GITHUB_PAT}

ARG REDCAP_SURVEY_API
ENV REDCAP_SURVEY_API=${REDCAP_SURVEY_API}


#Set working directory and copy the app
WORKDIR /home/app
COPY . /home/app


# Installation will just leverage the renv file
RUN R -e "source('./renv/activate.R'); renv::restore(confirm = TRUE)"
RUN R -e "install.packages('pkgload')"

# Establish ownership of the app for root
RUN chown -R root:root /home/app

# Expose the Shiny port
EXPOSE 3838

# Run the app locally
#CMD ["R", "-e", "renv::activate('/home/app'); shiny::runApp('/home/app', host='0.0.0.0', port=3838)"]

CMD ["R", "-e", "shiny::runApp('/home/app', host='0.0.0.0', port=3838)"]
