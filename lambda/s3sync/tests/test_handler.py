import unittest
from handler import handler
from tests.utils import load_event_from_file



def create_fake_s3_event(bucket: str, key: str) -> dict:
    return {
        "Records": [{
            "awsRegion": "eu-central-1",
            "s3": {
                "bucket": {"name": bucket},
                "object": {"key": key}
            }
        }]
    }


class TestHandler(unittest.TestCase):

    def test_handler_with_manual_event(self):
        event = create_fake_s3_event("my-bucket", "my-key.jpg")
        context = {}

        result = handler(event, context)

        self.assertEqual(result["bucket"], "my-bucket")
        self.assertEqual(result["key"], "my-key.jpg")

    def test_handler_correct_url_from_file(self):
        event = load_event_from_file("s3_object_created.json")
        context = {}

        result = handler(event, context)

        expected_url = "https://beeco-admin-images-test.s3.eu-central-1.amazonaws.com/partner-images/42/kitty-cat-kitten-pet-45201.jpeg"

        self.assertEqual(result["bucket"], "beeco-admin-images-test")
        self.assertEqual(result["key"], "partner-images/42/kitty-cat-kitten-pet-45201.jpeg")
        self.assertEqual(result["url"], expected_url)

if __name__ == "__main__":
    unittest.main()
