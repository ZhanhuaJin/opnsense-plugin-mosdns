<?php

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Backend;
use OPNsense\MosDNS\MosDNS;

class IPSetController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'ipset';
    protected static $internalModelClass = 'OPNsense\MosDNS\MosDNS';

    public function searchIPSetAction()
    {
        return $this->searchBase('ipset.ipset', array('enabled', 'name', 'files'));
    }

    public function getIPSetAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('ipset', 'ipset.ipset', $uuid);
    }

    public function addIPSetAction()
    {
        return $this->addBase('ipset', 'ipset.ipset');
    }

    public function delIPSetAction($uuid)
    {
        return $this->delBase('ipset.ipset', $uuid);
    }

    public function setIPSetAction($uuid)
    {
        return $this->setBase('ipset', 'ipset.ipset', $uuid);
    }

    public function toggleIPSetAction($uuid)
    {
        return $this->toggleBase('ipset.ipset', $uuid);
    }
}