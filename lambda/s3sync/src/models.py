from dataclasses import dataclass
from enum import Enum

class S3EventType(Enum):
  PUT = "Put"
  DELETE = "Delete"


class ImageCategory:
   objectKey: str
   databaseTableName: str


@dataclass
class S3ObjectData:
    """ Stores relevant S3 data. Currently only supports partner-images"""
    bucket: str
    eventType: "S3EventType"
    partnerId: int
    imageCategory: ImageCategory
    fileName: str
    imageUrl: str
    

