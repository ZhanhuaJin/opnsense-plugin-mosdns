<?php

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Backend;
use OPNsense\MosDNS\MosDNS;

class SequenceController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'sequence';
    protected static $internalModelClass = 'OPNsense\MosDNS\MosDNS';

    public function searchSequenceAction()
    {
        return $this->searchBase('sequence.sequence', array('enabled', 'name', 'exec', 'matches'));
    }

    public function getSequenceAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('sequence', 'sequence.sequence', $uuid);
    }

    public function addSequenceAction()
    {
        return $this->addBase('sequence', 'sequence.sequence');
    }

    public function delSequenceAction($uuid)
    {
        return $this->delBase('sequence.sequence', $uuid);
    }

    public function setSequenceAction($uuid)
    {
        return $this->setBase('sequence', 'sequence.sequence', $uuid);
    }

    public function toggleSequenceAction($uuid)
    {
        return $this->toggleBase('sequence.sequence', $uuid);
    }

    // Generic Item methods for frontend compatibility
    public function searchItemAction()
    {
        return $this->searchSequenceAction();
    }

    public function getItemAction($uuid = null)
    {
        return $this->getSequenceAction($uuid);
    }

    public function addItemAction()
    {
        return $this->addSequenceAction();
    }

    public function delItemAction($uuid)
    {
        return $this->delSequenceAction($uuid);
    }

    public function setItemAction($uuid)
    {
        return $this->setSequenceAction($uuid);
    }

    public function toggleItemAction($uuid)
    {
        return $this->toggleSequenceAction($uuid);
    }
}