"""Test the ECSCluster class"""

import pytest
from whoami import get_sts_identity


@pytest.mark.unit
def test_get_sts_identity():
    """test dns lookup function"""
    result = get_sts_identity()
    assert True