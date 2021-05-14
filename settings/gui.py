from tkinter import *

import i18n
import xfile

settings_url = ""
window = Tk()
settings = {}
elements = {
    'array': {},
    'bool': {},
    'string': {},
    'button': {
        'cancel': {},
        'ok': {}
    }
}

def on_btn_save():
    for b in elements['bool']:
        settings['bool'][b] = bool(elements['bool'][b].get())

    for s in elements['string']:
        settings['string'][s] = elements['string'][s].get("1.0","end-1c")

    for a in elements['array']:
        settings['array'][a] = []
        for i in range(elements['array'][a].size()):
            settings['array'][a].append(elements['array'][a].get(i))
    
    _on_btn_save()

def _on_btn_save():
    error = xfile.save_settings(settings_url, settings)
    if error:
        raise Exception(error) 

def on_btn_add(_stringvar, array_id):
    if array_id:
        new_element = _stringvar.get()
        if new_element[:2] != "*.":
            if new_element[0] == ".": 
                new_element = "*" + new_element
            else:
                new_element = "*." + new_element
        if new_element not in settings['array'][array_id]:
            settings['array'][array_id].append(new_element)
            elements['array'][array_id].insert(END, new_element)

def on_btn_save_preset(t_options, t_container, t_selected_preset):
    selected_preset_id = t_selected_preset.get("1.0", "end-1c")
    if selected_preset_id:
        new_options = t_options.get("1.0", "end-1c")
        new_container = t_container.get("1.0", "end-1c")
        settings['preset'][selected_preset_id]['options'] = new_options
        settings['preset'][selected_preset_id]['container'] = new_container
        _on_btn_save()

def on_btn_restore_preset(t_options, t_container, t_selected_preset):
    selected_preset_id = t_selected_preset.get("1.0", "end-1c")
    if selected_preset_id:
        t_options.delete("1.0", END)
        t_options.insert(INSERT, settings['preset_original'][selected_preset_id]['options'])
        t_container.delete("1.0", END)
        t_container.insert(INSERT, settings['preset_original'][selected_preset_id]['container'])

def _get_frame(padx=5, pady=0, relief=FLAT):
    return Frame( master=window, relief=relief, borderwidth=1, padx=padx, pady=pady )

def init_tk(_settings_url, _settings):
    global settings, settings_url
    settings = _settings
    settings_url = _settings_url
    window.option_add("*Font", "courier 10")

    # Bools / Check button
    for b in settings['bool']:
        b_frame = _get_frame()
        b_frame.pack()

        v = IntVar(value=int(settings['bool'][b]))
        c = Checkbutton(b_frame, text=b, variable=v)
        c.pack()
        elements['bool'][b] = v
    
    # Strings / Text
    for s in settings['string']:
        s_frame = _get_frame(padx=5)
        s_frame.pack()

        l = Label(s_frame, text=s)
        l.pack(side=LEFT)

        t = Text(s_frame, height=1, width=20)
        t.insert(INSERT, settings['string'][s])
        t.pack(side=RIGHT)
        elements['string'][s] = t
    
    # Arrays
    for i, a in enumerate(settings['array']):
        a_frame = _get_frame(relief=RAISED, pady=5)
        a_frame.pack()

        Label(a_frame, text=a).pack()
        lb = Listbox(a_frame,  height=5)
        for _a in settings['array'][a]:
            lb.insert(END, _a)
        lb.pack()
        elements['array'][a] = lb

        l = Label(a_frame, text=i18n.NEW_ELEMENT_EXTENSION).pack()
        v = StringVar()
        e = Entry(a_frame, textvariable=v)

        e.pack()

        btn_add = Button(a_frame, text=i18n.ADD_ELEMENT, command=lambda:on_btn_add(v, a))
        btn_add.pack(side=LEFT, pady=5, padx=10)
        btn_del = Button(a_frame, text=i18n.DEL_ELEMENT, command=lambda lb=lb: lb.delete(ANCHOR))
        btn_del.pack(side=LEFT, pady=5, padx=10)
    
    # Presets
    p_frame = _get_frame(relief=RAISED, padx=20, pady=5)
    p_frame.pack()
    
    Label(p_frame, text=i18n.PRESETS).pack()
    lb = Listbox(p_frame,  height=5)
    lb.pack()
    t_options = Text(p_frame, height=6, width=20)
    t_options.pack()
    t_container = Text(p_frame, height=1, width=20)
    t_container.pack()
    t_selected_preset = Text(p_frame)

    for p in settings['preset']:
        lb.insert(END, p)
    
    def on_select_preset(event):
        selection = event.widget.curselection()
        if selection:
            selected_preset_id = event.widget.get(selection[0])
            t_options.delete("1.0", END)
            t_options.insert(INSERT, settings['preset'][selected_preset_id]['options'])
            t_container.delete("1.0", END)
            t_container.insert(INSERT, settings['preset'][selected_preset_id]['container'])
            t_selected_preset.delete("1.0", END)
            t_selected_preset.insert(INSERT, selected_preset_id)

    lb.bind("<<ListboxSelect>>", on_select_preset)

    btn_save_preset = Button(p_frame, text=i18n.SAVE_PRESET, command=lambda:on_btn_save_preset(t_options, t_container, t_selected_preset))
    btn_save_preset.pack(side=LEFT, pady=5, padx=10)
    btn_restore_preset = Button(p_frame, text=i18n.RESTORE_PRESET, command=lambda:on_btn_restore_preset(t_options, t_container, t_selected_preset))
    btn_restore_preset.pack(side=LEFT, pady=5, padx=10)
    
    # General buttons & config
    btn_frame = _get_frame(pady=15)
    btn_frame.pack()

    btn_save = Button(btn_frame, text=i18n.SAVE, command=on_btn_save).pack(side=LEFT, padx=15)
    btn_cancel = Button(btn_frame, text=i18n.CANCEL, command=window.destroy).pack(side=RIGHT, padx=15)
    
    window.title(i18n.SETTINGS_TITLE)
    window.geometry("400x750+10+10")
    window.mainloop()
