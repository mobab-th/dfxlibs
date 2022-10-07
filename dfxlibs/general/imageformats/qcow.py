# coding: utf-8
"""
   support ewf file format

   Copyright 2022 Markus D (mar.d@gmx.net)

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
"""

import pytsk3
import pyqcow


class QCow(pytsk3.Img_Info):
    magic = b'QFI\xfb'

    def __init__(self, filenames):
        self._qcow_handle = pyqcow.file()
        self._qcow_handle.open(filenames[0])
        super().__init__()

    def close(self):
        self._qcow_handle.close()

    def read(self, offset, size):
        self._qcow_handle.seek(offset)
        return self._qcow_handle.read(size)

    def get_size(self):
        return self._qcow_handle.get_media_size()
