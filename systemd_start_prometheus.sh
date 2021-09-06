#!/bin/bash

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl status prometheus

