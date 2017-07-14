package com.lizhou.tools;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.text.DecimalFormat;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;

public class ExcelTool<T> {
	
	/**
	 * 导入Excel
	 * @param type
	 * @param filePath
	 * @return
	 * @throws IOException 
	 * @throws FileNotFoundException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws InvocationTargetException 
	 * @throws Exception
	 */
	public List<T> importExcel(Class<T> type, InputStream is) throws FileNotFoundException, IOException, InstantiationException, IllegalAccessException, InvocationTargetException {
		// 创建对Excel工作簿文件的引用
		HSSFWorkbook workbook = new HSSFWorkbook(is); 
		/*
		 * 在Excel文档中，第一张工作表的缺省索引是0 
		 * 其语句为：HSSFSheet sheet = workbook.getSheetAt(0);
		 * 根据表名获取: HSSFSheet sheet = wookbook.getSheet("Sheet1");
		 */
		HSSFSheet sheet = workbook.getSheetAt(0);
		//获取到Excel文件中的所有行数
        int rows = sheet.getPhysicalNumberOfRows();
        //标题行
        HSSFRow titleRow = null;
        int r = 0;
        for(; r < rows; r++){
        	// 读取一行
            HSSFRow row = sheet.getRow(r);
            // 行不为空
            if (row != null) {
            	titleRow = row; break;
            }
        }
        List<T> list = new LinkedList<T>();
        //用于格式化excel中的数值文本
        DecimalFormat df = new DecimalFormat("0");
        //遍历行，提取数据并封装
        r++;
        for (; r <= rows; r++) {
            HSSFRow row = sheet.getRow(r);
            if (row != null) {
            	T obj = type.newInstance();
            	//获取到该行中的所有的列
            	int cells = row.getPhysicalNumberOfCells();
                //遍历列
                for (int j = 0; j <= cells; j++) {
                	//获取到列的值
                    HSSFCell cell = row.getCell(j);
                    //获取列名
                    if (cell != null) {
                    	String name = titleRow.getCell(j).getStringCellValue();
                    	String value = "";
                    	switch (cell.getCellType()) {
                        	case HSSFCell.CELL_TYPE_FORMULA:
                        		break;
                            case HSSFCell.CELL_TYPE_NUMERIC:
                            	value = df.format(cell.getNumericCellValue());        
                                break;  
                        	case HSSFCell.CELL_TYPE_STRING:
                             	value = cell.getStringCellValue();
                                break;
                         	default:
                              	value = "";
                                break;
                    	}
                    	BeanUtils.setProperty(obj, name, value);
                    }      
                }
                list.add(obj);
            }
        }
		return list;
	}
	
	/**
	 * 导出
	 * @param headers
	 * @param list
	 * @param out
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws NoSuchMethodException
	 */
	public void exportExcel(String[] headers, List<T> list, OutputStream out) 
			throws IllegalAccessException, InvocationTargetException, NoSuchMethodException {
        // 声明一个工作薄
        HSSFWorkbook workbook = new HSSFWorkbook();
        // 生成一个表格
        HSSFSheet sheet = workbook.createSheet();
        // 生成一个样式
        HSSFCellStyle headerStyle = workbook.createCellStyle();
        // 设置这些样式
        headerStyle.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
        headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        // 生成一个字体
        HSSFFont font = workbook.createFont();
        font.setFontHeightInPoints((short) 12);
        font.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
        // 把字体应用到当前的样式
        headerStyle.setFont(font);

        // 产生表格标题行
        HSSFRow row = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            HSSFCell cell = row.createCell(i);
            cell.setCellStyle(headerStyle);
            //HSSFRichTextString text = new HSSFRichTextString(headers[i]);
            cell.setCellValue(headers[i]);
        }
        // 遍历集合数据，产生数据行
        int index = 0;
        for(T t : list) {
            index++;
            row = sheet.createRow(index);
            for (int i = 0; i < headers.length; i++) {
                HSSFCell cell = row.createCell(i);
                String value = BeanUtils.getProperty(t, headers[i]);
                cell.setCellValue(value);
            }
        }
        //输出
        try {
        	workbook.write(out);
    		out.close();
        } catch (IOException e) {
        	e.printStackTrace();
        }

    }
	
	public void exportMapExcel(String[] headers, List<Map<String, Object>> list, OutputStream out) 
			throws IllegalAccessException, InvocationTargetException, NoSuchMethodException {
        // 声明一个工作薄
        HSSFWorkbook workbook = new HSSFWorkbook();
        // 生成一个表格
        HSSFSheet sheet = workbook.createSheet();
        // 生成一个样式
        HSSFCellStyle headerStyle = workbook.createCellStyle();
        // 设置这些样式
//        headerStyle.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
//        headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        // 生成一个字体
//        HSSFFont font = workbook.createFont();
//        font.setFontHeightInPoints((short) 12);
//        font.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
//        // 把字体应用到当前的样式
//        headerStyle.setFont(font);

        // 产生表格标题行
        HSSFRow row = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            HSSFCell cell = row.createCell(i);
            cell.setCellStyle(headerStyle);
            //HSSFRichTextString text = new HSSFRichTextString(headers[i]);
            cell.setCellValue(headers[i]);
        }
        // 遍历集合数据，产生数据行
        int index = 0;
        for(Map<String, Object> map : list) {
            index++;
            row = sheet.createRow(index);
            
            Set<Entry<String, Object>> set = map.entrySet();
            
            Iterator<Entry<String, Object>> it = set.iterator();
            int i = 0;
            while(it.hasNext()){
            	
            	Entry<String, Object> next = it.next();
            	Object value = next.getValue();
            	String key = next.getKey();
            	if(!key.contains("escoreid")){
            		HSSFCell cell = row.createCell(i++);
                	if(value instanceof String){
                		String str = (String) value;
                		cell.setCellValue(str);
                	} else{
                		Integer score = (Integer) value;
                		cell.setCellValue(score.intValue());
                	}
            	}
            }
        }
        //输出
        try {
        	workbook.write(out);
    		out.close();
        } catch (IOException e) {
        	e.printStackTrace();
        }

    }
	
	
}
