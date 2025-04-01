# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
import json
import urllib.parse
import logging
import os

log_level_str = os.getenv("LOG_LEVEL", "INFO").upper()
log_level = getattr(logging, log_level_str, logging.INFO)

logger = logging.getLogger()
logger.setLevel(log_level)



def handler(event, context):
    logger.debug("Received event: %s", json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    region = event['Records'][0]['awsRegion']
    
    object_url = f"https://{bucket}.s3.{region}.amazonaws.com/{key}"

    print( {
        "bucket": bucket,
        "key": key,
        "url": object_url

    })

