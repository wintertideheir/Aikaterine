#include "ui.h"

#include <stdlib.h>
#include <stdarg.h>

struct UIElementScaled
{
    struct UIElement  *element;
    struct FloatTuple element_scale;
};

struct UIElementArray
{
    int              elements_length;
    struct UIElement **elements;
    float            *elements_sizes;
};

enum UIElementType
{
    UIELEMENT_SCALED,
    UIELEMENT_VERTICAL,
    UIELEMENT_HORIZONTAL,
    UIELEMENT_TEXT,
    UIELEMENT_BUTTON
};

union UIElementValue
{
    struct UIElementScaled scaled;
    struct UIElementArray  array;
    const char             *text;
};

struct UIElement
{
    enum UIElementType   type;
    union UIElementValue value;
};

struct UIElement *uielement_scaled(struct UIElement *element, struct FloatTuple scale)
{
    struct UIElement *e = malloc(sizeof(struct UIElement));
    e->type = UIELEMENT_SCALED;
    e->value.scaled =
        (struct UIElementScaled)
            {.element       = element,
             .element_scale = scale};
    return e;
}

struct UIElement *uielement_array(va_list va, int length)
{
    struct UIElement *e = malloc(sizeof(struct UIElement));
    struct UIElement **elements      = malloc(sizeof(struct UIElement[length]));
    float            *elements_sizes = malloc(sizeof(float[length]));
    for (int i = 0; i < length; i++)
    {
        elements[i]       = va_arg(va, struct UIElement*);
        elements_sizes[i] = va_arg(va, int);
    }
    e->value.array =
        (struct UIElementArray)
            {.elements_length = length,
             .elements        = elements,
             .elements_sizes  = elements_sizes};
    return e;
}

struct UIElement *uielement_vertical(int length, ...)
{
    va_list va;
    va_start(va, length);
    struct UIElement *e = uielement_array(va, length);
    va_end(va);

    e->type = UIELEMENT_VERTICAL;
    return e;
}

struct UIElement *uielement_horizontal(int length, ...)
{
    va_list va;
    va_start(va, length);
    struct UIElement *e = uielement_array(va, length);
    va_end(va);

    e->type = UIELEMENT_HORIZONTAL;
    return e;
}

struct UIElement *uielement_text(const char* text)
{
    struct UIElement *e = malloc(sizeof(struct UIElement));
    e->type = UIELEMENT_TEXT;
    e->value.text = text;
    return e;
}

struct UIElement *uielement_button()
{
    struct UIElement *e = malloc(sizeof(struct UIElement));
    e->type = UIELEMENT_BUTTON;
    return e;
}

void uielement_destructor(struct UIElement *element)
{
    switch (element->type)
    {
        case UIELEMENT_SCALED:
            uielement_destructor(element->value.scaled.element);
            free(element);
            break;
        case UIELEMENT_VERTICAL:
        case UIELEMENT_HORIZONTAL:
            for (int i = 0; i < element->value.array.elements_length; i++)
            {
                uielement_destructor(element->value.array.elements[i]);
                free(element->value.array.elements);
                free(element->value.array.elements_sizes);
            }
            free(element);
            break;
        case UIELEMENT_TEXT:        
        case UIELEMENT_BUTTON:
            free(element);
            break;
        default:
            break;
    }
}
