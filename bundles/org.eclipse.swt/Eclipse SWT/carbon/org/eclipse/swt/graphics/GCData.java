/*******************************************************************************
 * Copyright (c) 2000, 2003 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 * 
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
package org.eclipse.swt.graphics;


import org.eclipse.swt.*;
import org.eclipse.swt.internal.carbon.Rect;

/**
 * Instances of this class are descriptions of GCs in terms
 * of unallocated platform-specific data fields.
 * <p>
 * <b>IMPORTANT:</b> This class is <em>not</em> part of the public
 * API for SWT. It is marked public only so that it can be shared
 * within the packages provided by SWT. It is not available on all
 * platforms, and should never be called from application code.
 * </p>
 */
public final class GCData {
	public Device device;
	public int style;
	public Image image;
	public float[] foreground;
	public float[] background;
	public int clipRgn;
	public int lineWidth = 1;
	public int lineStyle = SWT.LINE_SOLID;
	public int lineCap = SWT.CAP_FLAT;
	public int lineJoin = SWT.JOIN_MITER;
	public boolean xorMode;
	
	public Font font;
	public int fontAscent;
	public int fontDescent;
	public int layout;
	public int atsuiStyle;
	public int tabs;
	
	public String string;
	public int stringLength;
	public int stringWidth = -1;
	public int stringHeight = -1;
	public int drawFlags;
	public int stringPtr;
	
	public Thread thread;

	public int window;	
	public int paintEvent;
	public int visibleRgn;
	public int control;
	public int port;
	public Rect portRect;
	public Rect controlRect;	
	public boolean updateClip;
}
