using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for RangeRule
/// </summary>
/// 

public class InputRangeValidator
{
    object min, max;
    ValidateDataType type;
    public InputRangeValidator(object min, object max, ValidateDataType type)
	{
        this.min = min;
        this.max = max;
        this.type = type;
	}

    public bool Validate(object value)
    {
        bool res = false;
        switch (type)
        {
            case ValidateDataType.CHAR:
                res = ValidateChar(Convert.ToChar(value));
                break;
            case ValidateDataType.DATE:
                if (value.GetType() == typeof(DateTime))
                {
                    res = ValidateDate((DateTime)value);
                }
                else if (value.GetType() == typeof(string))
                {
                    if (value.ToString().Contains('-'))
                        res = ValidateDate(DateTime.ParseExact(value.ToString(), "dd-MM-yyyy", null));
                    else if (value.ToString().Contains('/'))
                        res = ValidateDate(DateTime.ParseExact(value.ToString(), "dd/MM/yyyy", null));
                }
                break;
            case ValidateDataType.DECIMAL:
                res = ValidateDecimal(Convert.ToDecimal(value));
                break;
            case ValidateDataType.NUMBER:
                res = ValidateNumber(Convert.ToInt64(value));
                break;
        }
        return res;
    }

    private bool ValidateChar(char value)
    {
        bool res=false;
        char min_val, max_val;
        if (min != null && max != null)
        {
            min_val = Convert.ToChar(min);
            max_val = Convert.ToChar(max);
            res = value >= min_val && value <= max_val;
        }
        else if (min == null && max != null)
        {
            max_val = Convert.ToChar(max);
            res = value <= max_val;
        }
        else if (min != null && max == null)
        {
            min_val = Convert.ToChar(min);
            res = value >= min_val;
        }
        return res;
    }

    private bool ValidateDate(DateTime value)
    {
        bool res = false;
        DateTime min_val, max_val;
        if (min != null && max != null)
        {
            min_val = (DateTime)min;
            max_val = (DateTime)max;
            res = value >= min_val && value <= max_val;
        }
        else if (min == null && max != null)
        {
            max_val = (DateTime)max;
            res = value <= max_val;
        }
        else if (min != null && max == null)
        {
            min_val = (DateTime)min;
            res = value >= min_val;
        }
        return res;
    }

    private bool ValidateDecimal(decimal value)
    {
        bool res = false;
        decimal min_val, max_val;
        if (min != null && max != null)
        {
            min_val = Convert.ToDecimal(min);
            max_val = Convert.ToDecimal(max);
            res = value >= min_val && value <= max_val;
        }
        else if (min == null && max != null)
        {
            max_val = Convert.ToDecimal(max);
            res = value <= max_val;
        }
        else if (min != null && max == null)
        {
            min_val = Convert.ToDecimal(min);
            res = value >= min_val;
        }
        return res;
    }

    private bool ValidateNumber(long value)
    {
        bool res = false;
        long min_val, max_val;
        if (min != null && max != null)
        {
            min_val = Convert.ToInt64(min);
            max_val = Convert.ToInt64(max);
            res = value >= min_val && value <= max_val;
        }
        else if (min == null && max != null)
        {
            max_val = Convert.ToInt64(max);
            res = value <= max_val;
        }
        else if (min != null && max == null)
        {
            min_val = Convert.ToInt64(min);
            res = value >= min_val;
        }
        return res;
    }
}