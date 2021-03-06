/*******************************************************************************
 * Copyright (c) 2000, 2017 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    IBM Corporation - initial API and implementation
 *******************************************************************************/
package org.eclipse.swt.internal.cocoa;

public class NSProgressIndicator extends NSView {

public NSProgressIndicator() {
	super();
}

public NSProgressIndicator(long /*int*/ id) {
	super(id);
}

public NSProgressIndicator(id id) {
	super(id);
}

public long /*int*/ controlSize() {
	return OS.objc_msgSend(this.id, OS.sel_controlSize);
}

public double doubleValue() {
	return OS.objc_msgSend_fpret(this.id, OS.sel_doubleValue);
}

public double maxValue() {
	return OS.objc_msgSend_fpret(this.id, OS.sel_maxValue);
}

public double minValue() {
	return OS.objc_msgSend_fpret(this.id, OS.sel_minValue);
}

public void setControlSize(long /*int*/ controlSize) {
	OS.objc_msgSend(this.id, OS.sel_setControlSize_, controlSize);
}

public void setDoubleValue(double doubleValue) {
	OS.objc_msgSend(this.id, OS.sel_setDoubleValue_, doubleValue);
}

public void setIndeterminate(boolean indeterminate) {
	OS.objc_msgSend(this.id, OS.sel_setIndeterminate_, indeterminate);
}

public void setMaxValue(double maxValue) {
	OS.objc_msgSend(this.id, OS.sel_setMaxValue_, maxValue);
}

public void setMinValue(double minValue) {
	OS.objc_msgSend(this.id, OS.sel_setMinValue_, minValue);
}

public void setUsesThreadedAnimation(boolean usesThreadedAnimation) {
	OS.objc_msgSend(this.id, OS.sel_setUsesThreadedAnimation_, usesThreadedAnimation);
}

public void sizeToFit() {
	OS.objc_msgSend(this.id, OS.sel_sizeToFit);
}

public void startAnimation(id sender) {
	OS.objc_msgSend(this.id, OS.sel_startAnimation_, sender != null ? sender.id : 0);
}

public void stopAnimation(id sender) {
	OS.objc_msgSend(this.id, OS.sel_stopAnimation_, sender != null ? sender.id : 0);
}

}
