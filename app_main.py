import re
from flask import Flask, jsonify, render_template, request, redirect, url_for, flash
from bs4 import BeautifulSoup
from datetime import datetime
import pyodbc
import requests


app = Flask(__name__)
app.secret_key = "your_secret_key"
def connect_db_web():
    try:
        conn = pyodbc.connect(
            'DRIVER={SQL Server};'
            'SERVER=127.0.0.1;'    
            'DATABASE=DLTT;'      
            'UID=sa;'               
            'PWD=123456;'           
        )
        print("Kết nối tới SQL Server thành công.")
        return conn
    except pyodbc.Error as e:
        print("Lỗi kết nối tới SQL Server:", e)
        return None

# Trang chủ: hiển thị tất cả câu hỏi
@app.route('/app_web')
def index_web():
    connection = connect_db_web()
    if connection is None:
        flash("Lỗi kết nối cơ sở dữ liệu", "danger")
        return render_template('index_web.html', questions=[])

    cursor = connection.cursor()
    try:
        # Sử dụng JOIN để lấy thông tin từ cả hai bảng Cau_hoi và Mota
        cursor.execute("""
            SELECT 
                ch.ID, 
                ch.cau_hoi, 
                ch.dap_an_a, 
                ch.dap_an_b, 
                ch.dap_an_c, 
                ch.dap_an_d, 
                ch.dap_an_dung, 
                m.De_tai, 
                m.Nguon, 
                m.Link, 
                m.Thoigian  -- Corrected query
            FROM 
                Cau_hoi AS ch
            JOIN 
                Mota AS m 
            ON 
                ch.maMT = m.maMT
        """)
        questions = cursor.fetchall()
    except Exception as e:
        flash(f"Lỗi khi truy vấn cơ sở dữ liệu: {e}", "danger")
        questions = []
    finally:
        cursor.close()
        connection.close()



    return render_template('index_web.html', questions=questions)


# Xóa câu hỏi
@app.route('/app_web/web_delete_question/<int:id>')
def web_delete_question(id):
    connection = connect_db_web()
    if connection is None:
        flash("Lỗi kết nối cơ sở dữ liệu", "danger")
        return redirect(url_for('index_web'))

    cursor = connection.cursor()
    try:
        cursor.execute("DELETE FROM Cau_hoi WHERE ID = ?", (id,))
        connection.commit()
        flash("Xóa câu hỏi thành công", "success")
    except Exception as e:
        flash(f"Lỗi khi xóa câu hỏi: {e}", "danger")
    finally:
        cursor.close()
        connection.close()

    return redirect(url_for('index_web'))


# Sửa câu hỏi
# Sửa câu hỏi
@app.route('/web_edit_question/<int:id>', methods=['GET', 'POST'])
def web_edit_question(id):
    connection = connect_db_web()
    if connection is None:
        flash("Lỗi kết nối cơ sở dữ liệu", "danger")
        return redirect(url_for('web_index'))

    cursor = connection.cursor()
    if request.method == 'POST':
        question_data = {
            'cau_hoi': request.form['cau_hoi'],
            'dap_an_a': request.form['dap_an_a'],
            'dap_an_b': request.form['dap_an_b'],
            'dap_an_c': request.form['dap_an_c'],
            'dap_an_d': request.form['dap_an_d'],
            'dap_an_dung': request.form['dap_an_dung']
        }

        if not all(question_data.values()):
            flash("Tất cả các trường đều phải được điền!", "warning")
            return redirect(url_for('web_edit_question', id=id))

        try:
            query = """
                UPDATE Cau_hoi
                SET cau_hoi = ?, dap_an_a = ?, dap_an_b = ?, dap_an_c = ?, dap_an_d = ?, dap_an_dung = ?
                WHERE ID = ?
            """
            values = (*question_data.values(), id)
            cursor.execute(query, values)
            connection.commit()
            flash("Cập nhật câu hỏi thành công", "success")
        except Exception as e:
            flash(f"Lỗi khi sửa câu hỏi: {e}", "danger")
        finally:
            cursor.close()
            connection.close()

        return redirect(url_for('index_web'))

    # Lấy câu hỏi để sửa (khi truy cập GET)
    try:
        cursor.execute("SELECT * FROM Cau_hoi WHERE ID = ?", (id,))
        question = cursor.fetchone()
        if not question:
            flash("Câu hỏi không tồn tại", "warning")
            return redirect(url_for('index'))
    except Exception as e:
        flash(f"Lỗi khi truy vấn câu hỏi: {e}", "danger")
        question = None
    finally:
        cursor.close()
        connection.close()

    return render_template('web_edit_question.html', question=question)






# TÌM
@app.route('/web_search_questions', methods=['GET'])
def web_search_questions():
    query = request.args.get('query', '')
    source = request.args.get('source', '')
    topic = request.args.get('topic', '')
    start_date = request.args.get('start_date', '')
    end_date = request.args.get('end_date', '')

    # Xử lý và định dạng ngày tháng
    if start_date:
        start_date = start_date.replace('T', ' ') + ":00.000"
    if end_date:
        end_date = end_date.replace('T', ' ') + ":59.999"

    connection = connect_db_web()

    if connection is None:
        return jsonify({"success": False, "message": "Lỗi kết nối cơ sở dữ liệu"})

    cursor = connection.cursor()

    try:
        # Xây dựng câu truy vấn SQL
        query_sql = """
            SELECT 
                ch.ID, 
                ch.cau_hoi, 
                ch.dap_an_a, 
                ch.dap_an_b, 
                ch.dap_an_c, 
                ch.dap_an_d, 
                ch.dap_an_dung, 
                m.De_tai, 
                m.Nguon, 
                m.link, 
                m.Thoigian
            FROM 
                Cau_hoi AS ch
            JOIN 
                Mota AS m 
            ON 
                ch.maMT = m.maMT
            WHERE 
        """
        conditions = []
        params = []

        if query:
            conditions.append("(ch.cau_hoi LIKE ? OR ch.ID LIKE ?)")
            params.extend([f"%{query}%", f"%{query}%"])
        if source:
            conditions.append("m.Nguon LIKE ?")
            params.append(f"%{source}%")
        if topic != "all":
            conditions.append("m.De_tai LIKE ?")
            params.append(f"%{topic}%")
        if start_date:
            conditions.append("m.Thoigian >= ?")
            params.append(start_date)
        if end_date:
            conditions.append("m.Thoigian <= ?")
            params.append(end_date)

        if not conditions:
            conditions.append("1=1")

        query_sql += " AND ".join(conditions)

        cursor.execute(query_sql, params)

        # Lấy dữ liệu và chuyển thành danh sách các câu hỏi
        rows = cursor.fetchall()
        questions = [dict(zip([column[0] for column in cursor.description], row)) for row in rows]

        return jsonify({"success": True, "questions": questions})

    except Exception as e:
        return jsonify({"success": False, "message": str(e)})

    finally:
        cursor.close()
        connection.close()



def get_text_or_none(element):
    """Trả về text của element nếu tồn tại, ngược lại trả về None."""
    return element.get_text(strip=True) if element else None

def fetch_questions_v2(url):
    try:
        response = requests.get(url)
        response.raise_for_status()  # Kiểm tra lỗi HTTP
    except requests.exceptions.RequestException as e:
        print("Lỗi khi kết nối tới URL:", e)
        return [], None, None  # Trả về danh sách rỗng và None cho tiêu đề và thời gian

    soup = BeautifulSoup(response.text, 'html.parser')
    questions = []

    # Lấy tiêu đề của trang
    title = soup.title.string.split(':')[-1].strip() if soup.title else "Không có tiêu đề"

    # Tìm tất cả các câu hỏi và đáp án
    question_blocks = soup.find_all('p')

    for question_block in question_blocks:
        question_text = question_block.get_text(strip=True)

        # Kiểm tra xem <p> này có phải là câu hỏi hay không
        if question_text.startswith("Câu") and ":" in question_text:
            # Lấy câu hỏi
            cau_hoi = question_text.split(":", 1)[1].strip()  # Phần sau dấu ":"

            # Tìm các đáp án
            dap_ans = []
            for _ in range(4):  # 4 đáp án A, B, C, D
                dap_an_elem = question_block.find_next_sibling('p')
                if dap_an_elem:
                    answer_span = dap_an_elem.find('span')
                    if answer_span:
                        dap_ans.append(get_text_or_none(answer_span))
                    question_block = dap_an_elem  # Cập nhật để tìm đáp án tiếp theo
            
           # Tìm đáp án đúng
            section_block = question_block.find_next('section', class_='toggle')
            if section_block:
                toggle_content = section_block.find('div', class_='toggle-content')

                if toggle_content:
                    # In ra nội dung để kiểm tra
                    print("Nội dung toggle_content:", toggle_content.get_text(strip=True))

                    # Lấy toàn bộ nội dung
                    toggle_text = toggle_content.get_text(strip=True)

                    # Tách phần đáp án và giải thích
                    if 'Đáp án:' in toggle_text:
                        # Tách nội dung tại vị trí "Đáp án:"
                        parts = toggle_text.split('Đáp án:')[1].strip()  # Lấy phần sau "Đáp án:"
                        dap_an_dung = parts.split('Giải thích:')[0].strip()  # Lấy phần trước "Giải thích:"
                    else:
                        dap_an_dung = None
                else:
                    dap_an_dung = None
            else:
                dap_an_dung = None


            
            # Đảm bảo có đủ 4 đáp án
            while len(dap_ans) < 4:
                dap_ans.append(None)

            # Định dạng lại dữ liệu
            formatted_question = (cau_hoi, dap_ans[0], dap_ans[1], dap_ans[2], dap_ans[3], dap_an_dung)
            questions.append(formatted_question)

    if not questions:
        print("Không tìm thấy câu hỏi nào trên trang.")
    else:
        print(f"Tìm thấy {len(questions)} câu hỏi.")

    # Lấy thời gian hiện tại
    timestamp = datetime.now()

    return questions, title, timestamp





def extract_question_data(url):
    try:
        response = requests.get(url)
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        print("Lỗi khi kết nối tới URL:", e)
        return [], None, None

    soup = BeautifulSoup(response.text, 'html.parser')

    # Lấy tiêu đề bài viết
    title_tag = soup.find('h1', class_='the-article-title')
    title_text = title_tag.get_text(strip=True).split(":")[-1].strip() if title_tag else "Tiêu đề không tìm thấy"

    # Lấy thời gian hiện tại
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Tìm tất cả các phần tử câu hỏi
    questions_data = []
    questions = soup.find_all('form', class_='box-van-dap form-cauhoi')

    for question in questions:
        question_number = question.find('span', class_='ptitle').get_text(strip=True)
        question_text = question.find('span', class_='underline').get_text(strip=True)
        
        # Lấy các đáp án và loại bỏ ký tự A., B., C., D.
        answers = []
        for label in question.find_all('label', class_='label-radio'):
            answer_text = label.get_text(strip=True)
            # Loại bỏ ký tự "A.", "B.", "C.", "D." nếu có
            if answer_text[1] == '.':
                answer_text = answer_text[2:].strip()  # Bỏ ký tự đầu tiên và dấu chấm
            answers.append(answer_text)

        # Đảm bảo có đúng 4 đáp án (A, B, C, D)
        while len(answers) < 4:
            answers.append(None)

        # Thêm dữ liệu câu hỏi (chưa có đáp án đúng)
        questions_data.append({
            'question_number': question_number,
            'question_text': question_text,
            'answers': answers,
            'correct_answer': None  # Sẽ được thêm sau
        })

    # Tìm phần đáp án từ bảng
    answer_section = soup.find('table', class_='table text-center')
    sorted_answers = []

    if answer_section:
        tbody = answer_section.find('tbody')
        if tbody:
            ans_text = tbody.get_text(strip=True)
            pattern = r"Câu (\d+)\s*([A-D])"
            matches = re.findall(pattern, ans_text)
            
            # Sắp xếp câu hỏi theo thứ tự và trích xuất đáp án
            answers = [(int(match[0]), match[1]) for match in matches]
            answers.sort(key=lambda x: x[0])
            sorted_answers = [answer[1] for answer in answers]
        else:
            print("Không tìm thấy tbody trong answer_section.")
    else:
        print("Không tìm thấy phần đáp án.")
    
    # Thêm từng đáp án từ sorted_answers vào đối tượng tương ứng trong questions_data
    for i in range(len(questions_data)):
        if i < len(sorted_answers):
            questions_data[i]['correct_answer'] = sorted_answers[i]

    # Chuyển đổi questions_data thành định dạng tương thích với process_questions
    formatted_questions = [
        (
            q['question_text'],       # Câu hỏi
            q['answers'][0],          # Đáp án A
            q['answers'][1],          # Đáp án B
            q['answers'][2],          # Đáp án C
            q['answers'][3],          # Đáp án D
            q['correct_answer']       # Đáp án đúng
        )
        for q in questions_data
    ]

    return formatted_questions, title_text, current_time
       


def insert_data(connection, questions, title, nguon, url, timestamp):
    # Check if there are no questions to insert
    if not questions:
        print("Không có dữ liệu để chèn vào database.")
        return
    
    cursor = connection.cursor()

    # SQL command to check if a question already exists
    check_sql = "SELECT COUNT(*) FROM Cau_hoi WHERE cau_hoi = ?"
    
    # SQL command to insert data into the CHTT table
    insert_sql_chtt = """
    INSERT INTO Cau_hoi (cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, maMT) 
    VALUES (?, ?, ?, ?, ?, ?, ?)
    """

    # SQL command to insert metadata into the DLTT table and get the ID
    insert_sql_dltt = """
    INSERT INTO Mota (De_tai, Nguon, Link, Thoigian) 
    OUTPUT INSERTED.MaMT 
    VALUES (?, ?, ?, ?)
    """
    
    # Count of successfully inserted questions
    inserted_count = 0

    print(f"Thu thập được {len(questions)} câu hỏi.")

    # Temporary variable to hold metadata ID (maMT) only if questions are inserted
    maMT = None

    # Insert each question into the CHTT table
    for question in questions:
        # Extract the question from the tuple
        cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung = question
        
        # Kiểm tra xem có trường nào là None không
        if None in [cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung]:
            print(f"Câu hỏi không hợp lệ và sẽ không được chèn: {cau_hoi}")
            continue  # Nếu có trường nào là None thì bỏ qua câu hỏi này

        # Check if the question already exists in the CHTT table
        cursor.execute(check_sql, (cau_hoi,))
        result = cursor.fetchone()

        if result[0] == 0:  # If the question does not exist
            # Insert metadata only once, when the first question is ready for insertion
            if maMT is None:
                try:
                    cursor.execute(insert_sql_dltt, (title, nguon, url, timestamp))
                    maMT = cursor.fetchone()[0]  # Get the ID of the last inserted row
                    print("Đã chèn metadata vào bảng MoTa.")
                except Exception as e:
                    print(f"Lỗi khi chèn metadata vào MoTa: {e}")
                    connection.rollback()  # Roll back if metadata insertion fails
                    cursor.close()
                    return

            try:
                # Insert the question into the CHTT table with the corresponding maMT
                cursor.execute(insert_sql_chtt, question + (maMT,))  # Add maMT to the question parameters
                inserted_count += 1
                print(f"Đã chèn câu hỏi: {cau_hoi}")
            except Exception as e:
                print(f"Lỗi khi chèn câu hỏi {cau_hoi}: {e}")
        else:
            print(f"Câu hỏi đã tồn tại: {cau_hoi}")

    # Commit all changes to the database if any questions were inserted
    if inserted_count > 0:
        connection.commit()
        print(f"Đã chèn {inserted_count} câu hỏi mới vào bảng CHTT.")
    else:
        print("Không có câu hỏi nào được chèn. Metadata sẽ không được lưu.")

    # Close the cursor
    cursor.close()

# Chỉ định duy nhất một endpoint '/fetch_questions'
@app.route('/fetch_questions', methods=['POST'])
def fetch_questions():
    try:
        data = request.get_json()  # Lấy dữ liệu JSON từ frontend
        print(f"Received data: {data}")  # In dữ liệu ra console để kiểm tra
        url = data.get('url')  # Lấy URL từ dữ liệu

        if not url:
            raise ValueError("URL is missing in the request")

        # Gọi hàm extract_question_data(url)
        questions, title, timestamp = extract_question_data(url)
        print(f"Extracted data: {questions}, {title}, {timestamp}")
        
        connection = connect_db_web()
        insert_data(connection, questions, title, "Doctailieu", url, timestamp)
        
        if questions:
            return jsonify({
                'success': True,
                'questions': questions,
                'title': title,
                'timestamp': timestamp
            })
        else:
            return jsonify({'success': False, 'message': 'Không thể lấy dữ liệu câu hỏi.'})
    
    except Exception as e:
        print(f"Lỗi khi xử lý yêu cầu: {e}")
        return jsonify({'success': False, 'message': str(e)})
    
@app.route('/app_web')
def app_web():
    return render_template('index_web.html')   


# Hàm kết nối với SQL Server
def connect_db_ai():
    try:
        conn = pyodbc.connect(
            'DRIVER={SQL Server};'
            'SERVER=127.0.0.1;'    
            'DATABASE=DLTS;'      
            'UID=sa;'               
            'PWD=123456;'           
        )
        print("Kết nối tới SQL Server thành công.")
        return conn
    except pyodbc.Error as e:
        print("Lỗi kết nối tới SQL Server:", e)
        return None

# Trang chủ: hiển thị tất cả câu hỏi
@app.route('/app_ai')
def index_ai():
    connection = connect_db_ai()
    if connection is None:
        flash("Lỗi kết nối cơ sở dữ liệu", "danger")
        return render_template('index_AI.html', questions=[])

    cursor = connection.cursor()
    try:
        # Sử dụng JOIN để lấy thông tin từ cả hai bảng Cau_hoi và Mota
        cursor.execute("""
            SELECT 
                ch.ID, 
                ch.cau_hoi, 
                ch.dap_an_a, 
                ch.dap_an_b, 
                ch.dap_an_c, 
                ch.dap_an_d, 
                ch.dap_an_dung, 
                m.De_tai, 
                m.Nguon, 
                m.Thoigian  -- Corrected query
            FROM 
                Cau_hoi AS ch
            JOIN 
                Mota AS m 
            ON 
                ch.maMT = m.maMT
        """)
        questions = cursor.fetchall()
    except Exception as e:
        flash(f"Lỗi khi truy vấn cơ sở dữ liệu: {e}", "danger")
        questions = []
    finally:
        cursor.close()
        connection.close()

    return render_template('index_AI.html', questions=questions)


# Xóa câu hỏi
@app.route('/app_ai/ai_delete_question/<int:id>')
def ai_delete_question(id):
    connection = tc_connect_db()
    if connection is None:
        flash("Lỗi kết nối cơ sở dữ liệu", "danger")
        return redirect(url_for('index_ai'))

    cursor = connection.cursor()
    try:
        cursor.execute("DELETE FROM Cau_hoi WHERE ID = ?", (id,))
        connection.commit()
        flash("Xóa câu hỏi thành công", "success")
    except Exception as e:
        flash(f"Lỗi khi xóa câu hỏi: {e}", "danger")
    finally:
        cursor.close()
        connection.close()

    return redirect(url_for('index_ai'))




# Sửa câu hỏi
@app.route('/ai_edit_question/<int:id>', methods=['GET', 'POST'])
def ai_edit_question(id):
    connection = connect_db_ai()
    if connection is None:
        flash("Lỗi kết nối cơ sở dữ liệu", "danger")
        return redirect(url_for('index_ai'))

    cursor = connection.cursor()
    if request.method == 'POST':
        question_data = {
            'cau_hoi': request.form['cau_hoi'],
            'dap_an_a': request.form['dap_an_a'],
            'dap_an_b': request.form['dap_an_b'],
            'dap_an_c': request.form['dap_an_c'],
            'dap_an_d': request.form['dap_an_d'],
            'dap_an_dung': request.form['dap_an_dung']
        }

        if not all(question_data.values()):
            flash("Tất cả các trường đều phải được điền!", "warning")
            return redirect(url_for('edit_question', id=id))

        try:
            query = """
                UPDATE Cau_hoi
                SET cau_hoi = ?, dap_an_a = ?, dap_an_b = ?, dap_an_c = ?, dap_an_d = ?, dap_an_dung = ?
                WHERE ID = ?
            """
            values = (*question_data.values(), id)
            cursor.execute(query, values)
            connection.commit()
            flash("Cập nhật câu hỏi thành công", "success")
        except Exception as e:
            flash(f"Lỗi khi sửa câu hỏi: {e}", "danger")
        finally:
            cursor.close()
            connection.close()

        return redirect(url_for('index_ai'))

    # Lấy câu hỏi để sửa (khi truy cập GET)
    try:
        cursor.execute("SELECT * FROM Cau_hoi WHERE ID = ?", (id,))
        question = cursor.fetchone()
        if not question:
            flash("Câu hỏi không tồn tại", "warning")
            return redirect(url_for('index_ai'))
    except Exception as e:
        flash(f"Lỗi khi truy vấn câu hỏi: {e}", "danger")
        question = None
    finally:
        cursor.close()
        connection.close()

    return render_template('edit_question.html', question=question)


# TÌM

# Tìm kiếm câu hỏi
@app.route('/ai_search_questions', methods=['GET'])
def ai_search_questions():
    query = request.args.get('query', '')
    source = request.args.get('source', '')
    topic = request.args.get('topic', '')
    start_date = request.args.get('start_date', '')
    end_date = request.args.get('end_date', '')

    # Xử lý và định dạng ngày tháng
    if start_date:
        start_date = start_date.replace('T', ' ') + ":00.000"
    if end_date:
        end_date = end_date.replace('T', ' ') + ":59.999"

    connection = connect_db_ai()

    if connection is None:
        return jsonify({"success": False, "message": "Lỗi kết nối cơ sở dữ liệu"})

    cursor = connection.cursor()

    try:
        # Xây dựng câu truy vấn SQL
        query_sql = """
            SELECT 
                ch.ID, 
                ch.cau_hoi, 
                ch.dap_an_a, 
                ch.dap_an_b, 
                ch.dap_an_c, 
                ch.dap_an_d, 
                ch.dap_an_dung, 
                m.De_tai, 
                m.Nguon, 
                m.Thoigian
            FROM 
                Cau_hoi AS ch
            JOIN 
                Mota AS m 
            ON 
                ch.maMT = m.maMT
            WHERE 
        """
        conditions = []
        params = []

        if query:
            conditions.append("(ch.cau_hoi LIKE ? OR ch.ID LIKE ?)")
            params.extend([f"%{query}%", f"%{query}%"])
        if source:
            conditions.append("m.Nguon LIKE ?")
            params.append(f"%{source}%")
        if topic != "all":
            conditions.append("m.De_tai LIKE ?")
            params.append(f"%{topic}%")
        if start_date:
            conditions.append("m.Thoigian >= ?")
            params.append(start_date)
        if end_date:
            conditions.append("m.Thoigian <= ?")
            params.append(end_date)

        if not conditions:
            conditions.append("1=1")

        query_sql += " AND ".join(conditions)

        cursor.execute(query_sql, params)

        # Lấy dữ liệu và chuyển thành danh sách các câu hỏi
        rows = cursor.fetchall()
        questions = [dict(zip([column[0] for column in cursor.description], row)) for row in rows]

        return jsonify({"success": True, "questions": questions})

    except Exception as e:
        return jsonify({"success": False, "message": str(e)})

    finally:
        cursor.close()
        connection.close()




def ai_insert_data(questions, title, nguon, timestamp):
    # Connect to the database
    connection = connect_db_ai()

    # Check if there are no questions to insert
    if not questions:
        print("Không có dữ liệu để chèn vào database.")
        return

    cursor = connection.cursor()

    # SQL command to check if a question already exists
    check_sql = "SELECT COUNT(*) FROM Cau_hoi WHERE cau_hoi = ?"
    
    # SQL command to insert data into the CHTT table
    insert_sql_chtt = """
    INSERT INTO Cau_hoi (cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, maMT) 
    VALUES (?, ?, ?, ?, ?, ?, ?)
    """

    # SQL command to insert metadata into the Mota table and get the ID
    insert_sql_dltt = """
    INSERT INTO Mota (De_tai, Nguon, Thoigian) 
    OUTPUT INSERTED.MaMT 
    VALUES (?, ?, ?)
    """
    
    # Count of successfully inserted questions
    inserted_count = 0

    print(f"Thu thập được {len(questions)} câu hỏi.")

    # Temporary variable to hold metadata ID (maMT) only if questions are inserted
    maMT = None

    # Insert each question into the CHTT table
    for question in questions:
        # Extract the fields from the question dictionary
        cau_hoi = question.get('cauhoi')
        dap_an_a = question.get('answer_a')
        dap_an_b = question.get('answer_b')
        dap_an_c = question.get('answer_c')
        dap_an_d = question.get('answer_d')
        dap_an_dung = question.get('dapandung')

        # Print the question for debugging
        print(question)

        # Check if any field is None
        missing_fields = [key for key, value in question.items() if value is None]
        if missing_fields:
            print(f"Câu hỏi không hợp lệ và sẽ không được chèn: {cau_hoi}. Các trường thiếu: {', '.join(missing_fields)}")
            continue  # Skip this question if any field is None

        # Check if the question already exists in the CHTT table
        cursor.execute(check_sql, (cau_hoi,))
        result = cursor.fetchone()

        if result[0] == 0:  # If the question does not exist
            # Insert metadata only once, when the first question is ready for insertion
            if maMT is None:
                try:
                    cursor.execute(insert_sql_dltt, (title, nguon, timestamp))
                    maMT = cursor.fetchone()[0]  # Get the ID of the last inserted row
                    print("Đã chèn metadata vào bảng MoTa.")
                except Exception as e:
                    print(f"Lỗi khi chèn metadata vào MoTa: {e}")
                    connection.rollback()  # Roll back if metadata insertion fails
                    cursor.close()
                    return

            try:
                # Insert the question into the CHTT table with the corresponding maMT
                cursor.execute(insert_sql_chtt, (cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, maMT))
                inserted_count += 1
                print(f"Đã chèn câu hỏi: {cau_hoi}")
            except Exception as e:
                print(f"Lỗi khi chèn câu hỏi {cau_hoi}: {e}")
                connection.rollback()  # Roll back if any question insertion fails
                cursor.close()
                return
        else:
            print(f"Câu hỏi đã tồn tại: {cau_hoi}")

    # Commit all changes to the database if any questions were inserted
    if inserted_count > 0:
        connection.commit()
        print(f"Đã chèn {inserted_count} câu hỏi mới vào bảng CHTT.")
    else:
        print("Không có câu hỏi nào được chèn. Metadata sẽ không được lưu.")

    # Close the cursor
    cursor.close()


# Flask endpoint to handle data insertion
@app.route('/ai_insert_data_endpoint', methods=['POST'])
def ai_insert_data_endpoint():
    data = request.get_json()
    title = data.get("topic")
    nguon = data.get("source")
    timestamp = data.get("timestamp") or datetime.now().isoformat()
    questions = data.get("questions", [])

    if not questions:
        return jsonify({"status": "failure", "message": "No questions to insert."})

    try:
        ai_insert_data(questions, title, nguon, timestamp)
        return jsonify({"status": "success", "message": "Data inserted successfully!"})
    except Exception as e:
        print("Error:", e)
        return jsonify({"status": "failure", "message": "Data insertion failed."})
    

@app.route('/app_ai')
def app_ai():
    return render_template('index_AI.html')  




# Hàm kết nối với SQL Server
def tc_connect_db():
    try:
        conn = pyodbc.connect(
            'DRIVER={SQL Server};'
            'SERVER=127.0.0.1;'    
            'DATABASE=DLTC;'      
            'UID=sa;'               
            'PWD=123456;'           
        )
        print("Kết nối tới SQL Server thành công.")
        return conn
    except pyodbc.Error as e:
        print("Lỗi kết nối tới SQL Server:", e)
        return None

# Trang chủ: hiển thị tất cả câu hỏi
# Trang chủ: hiển thị tất cả câu hỏi
@app.route('/')
@app.route('/app_tc')
def tc_index():
    connection = tc_connect_db()
    if connection is None:
        flash("Lỗi kết nối cơ sở dữ liệu", "danger")
        return render_template('index_thucong.html', questions=[])

    cursor = connection.cursor()
    try:
        # Sử dụng JOIN để lấy thông tin từ cả hai bảng Cau_hoi và Mota
        cursor.execute("""
            SELECT 
                ch.ID, 
                ch.cau_hoi, 
                ch.dap_an_a, 
                ch.dap_an_b, 
                ch.dap_an_c, 
                ch.dap_an_d, 
                ch.dap_an_dung, 
                m.De_tai, 
                m.Nguon,
                m.Thoigian  -- Corrected query
            FROM 
                Cau_hoi AS ch
            JOIN 
                Mota AS m 
            ON 
                ch.maMT = m.maMT
        """)
        questions = cursor.fetchall()
    except Exception as e:
        flash(f"Lỗi khi truy vấn cơ sở dữ liệu: {e}", "danger")
        questions = []
    finally:
        cursor.close()
        connection.close()



    return render_template('index_thucong.html', questions=questions)

# Thêm câu hỏi
@app.route('/add_question', methods=['POST'])
def tc_add_question():
    # Get the data from the form
    question_data = {
        'cau_hoi': request.form['cau_hoi'],
        'dap_an_a': request.form['dap_an_a'],
        'dap_an_b': request.form['dap_an_b'],
        'dap_an_c': request.form['dap_an_c'],
        'dap_an_d': request.form['dap_an_d'],
        'dap_an_dung': request.form['dap_an_dung'],
        'de_tai': request.form['de_tai'],  # New field for Topic
        'nguon': request.form['nguon'],  # New field for Source
        'thoi_gian': request.form['thoi_gian']  # New field for Time
    }

    print("Received data:", question_data)

    # Convert 'thoi_gian' to the correct datetime format if necessary
    try:
        # Database expects format 'YYYY-MM-DD HH:MM:SS.000'
        thoi_gian = datetime.strptime(question_data['thoi_gian'], '%Y-%m-%dT%H:%M')
        question_data['thoi_gian'] = thoi_gian.strftime('%Y-%m-%d %H:%M:%S.000')
    except Exception as e:
        print(f"Error converting time: {e}")
        flash("Lỗi chuyển đổi thời gian", "danger")
        return redirect(url_for('tc_index'))

    # Connect to the database
    connection = tc_connect_db()
    if connection is None:
        flash("Lỗi kết nối cơ sở dữ liệu", "danger")
        return redirect(url_for('tc_index'))

    cursor = connection.cursor()
    
    try:
        # Check if the question already exists
        check_sql = "SELECT COUNT(*) FROM Cau_hoi WHERE cau_hoi = ?"
        cursor.execute(check_sql, (question_data['cau_hoi'],))
        result = cursor.fetchone()
        print(f"Question count: {result[0]}")
        
        if result[0] > 0:
            flash("Câu hỏi đã tồn tại trong cơ sở dữ liệu", "warning")
            return redirect(url_for('tc_index'))

        # Insert metadata into Mota table
        insert_sql_dltt = """
        INSERT INTO Mota (De_tai, Nguon, Thoigian) 
        OUTPUT INSERTED.MaMT 
        VALUES (?, ?, ?)
        """
        cursor.execute(insert_sql_dltt, (question_data['de_tai'], question_data['nguon'], question_data['thoi_gian']))
        maMT = cursor.fetchone()
        
        if not maMT:
            print("Không thể lấy MaMT.")
            flash("Lỗi khi thêm dữ liệu mô tả", "danger")
            return redirect(url_for('tc_index'))

        maMT = maMT[0]  # Get the generated MaMT (metadata ID)
        print("MaMT:", maMT)

        # Insert question into Cau_hoi table
        insert_sql_cau_hoi = """
        INSERT INTO Cau_hoi (cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, maMT) 
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """
        values_cau_hoi = (
            question_data['cau_hoi'], question_data['dap_an_a'], question_data['dap_an_b'],
            question_data['dap_an_c'], question_data['dap_an_d'], question_data['dap_an_dung'], maMT
        )
        
        cursor.execute(insert_sql_cau_hoi, values_cau_hoi)
        print("Question inserted:", values_cau_hoi)

        # Commit the transaction
        connection.commit()
        print("Commit successful.")
        flash("Thêm câu hỏi thành công", "success")
    except Exception as e:
        print(f"Lỗi khi thêm câu hỏi: {e}")  # Print out the error
        flash(f"Lỗi khi thêm câu hỏi: {e}", "danger")
    finally:
        cursor.close()
        connection.close()

    return redirect(url_for('tc_index'))

# Xóa câu hỏi
@app.route('/app_tc/delete_question/<int:id>')
def tc_delete_question(id):
    connection = tc_connect_db()
    if connection is None:
        flash("Lỗi kết nối cơ sở dữ liệu", "danger")
        return redirect(url_for('tc_index'))

    cursor = connection.cursor()
    try:
        cursor.execute("DELETE FROM Cau_hoi WHERE ID = ?", (id,))
        connection.commit()
        flash("Xóa câu hỏi thành công", "success")
    except Exception as e:
        flash(f"Lỗi khi xóa câu hỏi: {e}", "danger")
    finally:
        cursor.close()
        connection.close()

    return redirect(url_for('tc_index'))

# Sửa câu hỏi
@app.route('/tc_edit_question/<int:id>', methods=['GET', 'POST'])
def tc_edit_question(id):
    connection = tc_connect_db()
    if connection is None:
        flash("Lỗi kết nối cơ sở dữ liệu", "danger")
        return redirect(url_for('tc_index'))

    cursor = connection.cursor()
    if request.method == 'POST':
        question_data = {
            'cau_hoi': request.form['cau_hoi'],
            'dap_an_a': request.form['dap_an_a'],
            'dap_an_b': request.form['dap_an_b'],
            'dap_an_c': request.form['dap_an_c'],
            'dap_an_d': request.form['dap_an_d'],
            'dap_an_dung': request.form['dap_an_dung']
        }

        if not all(question_data.values()):
            flash("Tất cả các trường đều phải được điền!", "warning")
            return redirect(url_for('tc_edit_question', id=id))

        try:
            query = """
                UPDATE Cau_hoi
                SET cau_hoi = ?, dap_an_a = ?, dap_an_b = ?, dap_an_c = ?, dap_an_d = ?, dap_an_dung = ?
                WHERE ID = ?
            """
            values = (*question_data.values(), id)
            cursor.execute(query, values)
            connection.commit()
            flash("Cập nhật câu hỏi thành công", "success")
        except Exception as e:
            flash(f"Lỗi khi sửa câu hỏi: {e}", "danger")
        finally:
            cursor.close()
            connection.close()

        return redirect(url_for('tc_index'))

    # Lấy câu hỏi để sửa (khi truy cập GET)
    try:
        cursor.execute("SELECT * FROM Cau_hoi WHERE ID = ?", (id,))
        question = cursor.fetchone()
        if not question:
            flash("Câu hỏi không tồn tại", "warning")
            return redirect(url_for('tc_index'))
    except Exception as e:
        flash(f"Lỗi khi truy vấn câu hỏi: {e}", "danger")
        question = None
    finally:
        cursor.close()
        connection.close()

    return render_template('edit_question.html', question=question)

# Tìm kiếm câu hỏi
@app.route('/tc_search_questions', methods=['GET'])
def tc_search_questions():
    query = request.args.get('query', '')
    source = request.args.get('source', '')
    topic = request.args.get('topic', '')
    start_date = request.args.get('start_date', '')
    end_date = request.args.get('end_date', '')

    # Xử lý và định dạng ngày tháng
    if start_date:
        start_date = start_date.replace('T', ' ') + ":00.000"
    if end_date:
        end_date = end_date.replace('T', ' ') + ":59.999"

    connection = tc_connect_db()

    if connection is None:
        return jsonify({"success": False, "message": "Lỗi kết nối cơ sở dữ liệu"})

    cursor = connection.cursor()

    try:
        # Xây dựng câu truy vấn SQL
        query_sql = """
            SELECT 
                ch.ID, 
                ch.cau_hoi, 
                ch.dap_an_a, 
                ch.dap_an_b, 
                ch.dap_an_c, 
                ch.dap_an_d, 
                ch.dap_an_dung, 
                m.De_tai, 
                m.Nguon, 
                m.Thoigian
            FROM 
                Cau_hoi AS ch
            JOIN 
                Mota AS m 
            ON 
                ch.maMT = m.maMT
            WHERE 
        """
        conditions = []
        params = []

        if query:
            conditions.append("(ch.cau_hoi LIKE ? OR ch.ID LIKE ?)")
            params.extend([f"%{query}%", f"%{query}%"])
        if source:
            conditions.append("m.Nguon LIKE ?")
            params.append(f"%{source}%")
        if topic != "all":
            conditions.append("m.De_tai LIKE ?")
            params.append(f"%{topic}%")
        if start_date:
            conditions.append("m.Thoigian >= ?")
            params.append(start_date)
        if end_date:
            conditions.append("m.Thoigian <= ?")
            params.append(end_date)

        if not conditions:
            conditions.append("1=1")

        query_sql += " AND ".join(conditions)

        cursor.execute(query_sql, params)

        # Lấy dữ liệu và chuyển thành danh sách các câu hỏi
        rows = cursor.fetchall()
        questions = [dict(zip([column[0] for column in cursor.description], row)) for row in rows]

        return jsonify({"success": True, "questions": questions})

    except Exception as e:
        return jsonify({"success": False, "message": str(e)})

    finally:
        cursor.close()
        connection.close()





@app.route('/app_thucong')
def app_tc():
    return render_template('index_thucong.html')
if __name__ == '__main__':
    app.run(debug=True, port=8080)
