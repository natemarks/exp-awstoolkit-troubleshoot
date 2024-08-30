"""Test the ECSCluster class"""

import pytest
from whoami import get_sts_identity


@pytest.mark.unit
def test_get_sts_identity():
    """test dns lookup function"""
    result = {}
    response = get_sts_identity()
    result["UserId"] = response["UserId"]
    result["Account"] = response["Account"]
    result["Arn"] = response["Arn"]

    assert result["Account"] == "151924297945"
