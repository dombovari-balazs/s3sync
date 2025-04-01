# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
import json
import urllib.parse
import boto3
import logging
import os

log_level_str = os.getenv("LOG_LEVEL", "INFO").upper()
log_level = getattr(logging, log_level_str, logging.INFO)

logger = logging.getLogger()
logger.setLevel(log_level)

s3 = boto3.client('s3')


def handler(event, context):
    logger.debug("Received event: %s", json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        content_type = response['ContentType']
        logger.info("Successfully retrieved object '%s' from bucket '%s'", key, bucket)
        logger.info("Content type: %s", content_type)
        return response['ContentType']
    except Exception as e:
        logger.exception("Error getting object '%s' from bucket '%s'. Ensure it exists and is in the correct region.", key, bucket)
        raise e
              
